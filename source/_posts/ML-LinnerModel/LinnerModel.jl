using Plots;
using Latexify;
using Random;
pyplot()

# range(0,2π,50)

# 定义一些常量、工具函数（添加噪声、计算均方误差）
MAX_ORDER = 9                         # 阶数
MAX_DATA_NUM = 100                    #
MAX_NOISE = 0.1                       #
λ = 1                                 # 正则项系数
α = 0.05                              # 学习率
Momentum = 0.9                        # 动量，为了快速收敛
MAX_ITER = 10000                      # 最大迭代次数
BATCH_SIZE = 25                       # 批次
rng = MersenneTwister(1234);
noise(x) = x + MAX_NOISE * randn(rng,Float64,size(x))

f(x) = sin(2π * x)

# 损失函数 无正则/有正则
E(y_real,y_predict) = 0.5 * (sum([Δy^2 for Δy in y_predict .- y_real])) / length(y_real)
E_l(y_real,y_predict,W_hat) = 0.5 * ((sum([Δy^2 for Δy in y_predict .- y_real]) + sum([w^2 for w in W_hat]))) / length(y_real)

# 用于绘图
function W_Plot(X,Y,W)
    x_Plot = 0:0.01:1
    X_Plot = reshape([xd^i for i in MAX_ORDER:-1:0 for xd in x_Plot],length(x_Plot),MAX_ORDER+1)
    Y_Plot = X_Plot * W

    scatter(X,Y,label="data")
    plot!(x_Plot,f.(x_Plot),label="real(x)")
    plot!(x_Plot,Y_Plot,label="predict(x)")
end

# 生成标签数据
x_r = range(0,stop=1,length=MAX_DATA_NUM)
X_r = reshape([xd^i for i in MAX_ORDER:-1:0 for xd in x_r],length(x_r),MAX_ORDER+1)
Y_r = noise(f.(x_r))        # y_real

# 解析解 无正则项
# E_{W^̂} = \frac{1}{length(X)} ∑ (y - xw^̂))^2
# E_{W^̂} = \frac{1}{length(X)} (y - XW^̂)^T(y - XW^̂)
# \frac{∂E_{W^̂}}{∂W^̂} = \frac{1}{length(X)} 2X^T(XW^̂ - y)
# \frac{∂E_{W^̂}}{∂W^̂} = 0
#      ==> W^̂ = (X^TX)^{-1}X^Ty

W_hat = (X_r' * X_r)^-1 * X_r' * Y_r

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)

# 解析解 有正则项
# E_{W^̂} = \frac{1}{length(X)} [ ∑(xw^̂ -y)^2 + λ∑w^̂^2 ]
# E_{W^̂} = \frac{1}{length(X)} [ (XW^̂ - y)^T(XW^̂ - y) + λW^̂^T * W^̂ ]
# \frac{∂E_{W^̂}}{∂W^̂} = \frac{1}{length(X)} [2X^T(XW^̂ - y) + 2λW^̂]
# \frac{∂E_{W^̂}}{∂W^̂} = 0
#      ==> W^̂ = (X^T * X + λ )^{-1}X^Ty

W_hat = (X_r' * X_r .+ λ)^-1 * X_r' * Y_r

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)

λs = []
for λ in -1:0.01:10
    W_hat = (X_r' * X_r .+ λ)^-1 * X_r' * Y_r
    push!(λs,λ=>E(Y_r,X_r * W_hat))
end
plot([x[1] for x in λs],[y[2] for y in λs])

# 梯度下降 无正则项
# W = W - α\frac{∂E_{W}}{∂W}
W_hat = ones(MAX_ORDER+1)
v = zeros(MAX_ORDER+1)
α = 0.05

for i = 1:MAX_ITER
    global W_hat,v
    ∂E_W = (X_r' * (X_r * W_hat - Y_r)) * (2 / MAX_DATA_NUM)
    v = Momentum * v - α * ∂E_W
    W_hat += v
end

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)

# 梯度下降 有正则项
W_hat = ones(MAX_ORDER+1)
v = zeros(MAX_ORDER+1)

for i = 1:MAX_ITER
    global W_hat,v
    ∂E_W = (X_r' * (X_r * W_hat - Y_r) + λ * W_hat) * (2 / MAX_DATA_NUM)
    v = Momentum * v - α * ∂E_W
    W_hat += v
end

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)

# 随机梯度下降 无正则项
# W = W - α\frac{∂E_{W}}{∂W}
W_hat = zeros(MAX_ORDER+1)
v = zeros(MAX_ORDER+1)

for i = 1:MAX_ITER
    global W_hat,v
    p = rand(1:MAX_DATA_NUM,BATCH_SIZE)
    ∂E_W = (X_r[p,:]' * (X_r[p,:] * W_hat - Y_r[p])) * (2 / BATCH_SIZE)
    v = Momentum * v - α * ∂E_W
    W_hat += v
end

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)

# 随机梯度下降 有正则项
W_hat = zeros(MAX_ORDER+1)
v = zeros(MAX_ORDER+1)

for i = 1:MAX_ITER
    global W_hat,v
    p = rand(1:MAX_DATA_NUM,BATCH_SIZE)
    ∂E_W = (X_r[p,:]' * (X_r[p,:] * W_hat - Y_r[p]) + λ * W_hat) * (2 / BATCH_SIZE)
    v = Momentum * v - α * ∂E_W
    W_hat += v
end

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)

# 共轭梯度下降 无正则项
# \frac{∂E_{W^̂}}{∂W^̂} = \frac{1}{length(X)} 2X^T(XW^̂ - y)
# X^T X W^̂ = X^T Y
#    A  X  = b

A = X_r' * X_r
b = X_r' * Y_r
W_hat = zeros(MAX_ORDER+1)

rk = b - A * W_hat
pk = rk

while true
    global W_hat,rk,pk
    αk = rk' * rk / (pk' * A * pk)
    W_hat = W_hat + αk * pk
    rk2 = rk -  αk * A * pk

    loss = E(Y_r,X_r * W_hat)
    rk_l2 = sum([x^2 for x in rk2])
    if loss < 0.01
        println("Loss:$(loss) Rk:$(rk_l2)")
        break
    else
        println("Loss:$(loss) Rk:$(rk_l2)")
    end

    Βk = rk2' * rk2 /  (rk' * rk)
    pk2 = rk2 + Βk * pk

    rk = rk2
    pk = pk2
end

W_Plot(x_r,Y_r,W_hat)
E(Y_r,X_r * W_hat)
