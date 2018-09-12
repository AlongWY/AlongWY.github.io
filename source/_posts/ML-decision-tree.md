---
title: 机器学习之决策树
tags:
  - Mathine Learing
mathjax: true
date: 2018-09-11 22:30:42
categories:
  - 机器学习
---

# 决策树

决策树（decision tree）是一种基本的分类与回归方法，此处主要讨论分类的决策树。

在分类问题中，表示基于特征对实例进行分类的过程，可以认为是if-then的集合，也可以认为是定义在特征空间与类空间上的条件概率分布。

<!-- more -->
## 决策树的特点

* 优点：计算复杂度不高，输出结果易于理解，对中间值的缺失不敏感，可以处理不相关特征数据。
* 缺点：可能会产生过度匹配的问题
* 适用数据类型：数值型和标称型

* 决策树学习的目标：根据给定的训练数据集构建一个决策树模型，使它能够对实例进行正确的分类。
* 决策树学习的本质：从训练集中归纳出一组分类规则，或者说是由训练数据集估计条件概率模型。
* 决策树学习的损失函数：正则化的极大似然函数
* 决策树学习的测试：最小化损失函数
* 决策树学习的目标：在损失函数的意义下，选择最优决策树的问题。
* 决策树原理和问答猜测结果游戏相似，根据一系列数据，然后给出游戏的答案。 

## 决策树的建立过程
决策树通常有三个步骤：特征选择、决策树的生成、决策树的修剪。

用决策树分类：从根节点开始，对实例的某一特征进行测试，根据测试结果将实例分配到其子节点，此时每个子节点对应着该特征的一个取值，如此递归的对实例进行测试并分配，直到到达叶节点，最后将实例分到叶节点的类中。

## 使用决策树做预测

1. 收集数据：可以使用任何方法。比如想构建一个相亲系统，我们可以从媒婆那里，或者通过参访相亲对象获取数据。根据他们考虑的因素和最终的选择结果，就可以得到一些供我们利用的数据了。
2. 准备数据：收集完的数据，我们要进行整理，将这些所有收集的信息按照一定规则整理出来，并排版，方便我们进行后续处理。
3. 分析数据：可以使用任何方法，决策树构造完成之后，我们可以检查决策树图形是否符合预期。
4. 训练算法：这个过程也就是构造决策树，同样也可以说是决策树学习，就是构造一个决策树的数据结构。
5. 测试算法：使用经验树计算错误率。当错误率达到了可接收范围，这个决策树就可以投放使用了。
6. 使用算法：此步骤可以使用适用于任何监督学习算法，而使用决策树可以更好地理解数据的内在含义。

# 数学知识储备

请参考{% post_link ML-prepare-math 机器学习数学预备知识 %}。

# 决策树的构造

决策树学习的算法通常是一个递归地选择最优特征，并根据该特征对训练数据进行分割，使得各个子数据集有一个最好的分类的过程。这一过程对应着对特征空间的划分，也对应着决策树的构建。

1. 开始：构建根节点，将所有训练数据都放在根节点，选择一个最优特征，按着这一特征将训练数据集分割成子集，使得各个子集有一个在当前条件下最好的分类。
2. 如果这些子集已经能够被基本正确分类，那么构建叶节点，并将这些子集分到所对应的叶节点去。
3. 如果还有子集不能够被正确的分类，那么就对这些子集选择新的最优特征，继续对其进行分割，构建相应的节点，如果递归进行，直至所有训练数据子集被基本正确的分类，或者没有合适的特征为止。
4. 每个子集都被分到叶节点上，即都有了明确的类，这样就生成了一颗决策树。


-------------------------------------------

**没有代码的说教都是耍流氓！！！**

下面给出具体实现(以信息增益作为划分标准)：

```julia
using DataFrames, CSV;

function calcEnt(datasets)
    num_samples = size(datasets,1)
    label_counts = Dict()
    for label in datasets[end]
        if label in keys(label_counts)
            label_counts[label] += 1
        else
            label_counts[label] = 1
        end
    end
    # $ Ent(D) = - ∑_{p ∈ P} p log_2(p) $
    return - sum([p * log2(p) for p in values(label_counts) ./ num_samples ])
end

function calcGain(datasets,class,ent = calcEnt(datasets))
    num_samples = size(datasets,1)
    groups = groupby(datasets, class)
    entries = [(size(subsets,1),calcEnt(subsets)) for subsets in groups]
    # $Gain(D,a) = Ent(D) - ∑_{v ∈ V} \frac{|D^v|}{|D|} Ent(D^v)$
    return ent - sum([group_size / num_samples * grout_ent for (group_size,grout_ent) in entries])
end

function createTree(datasets,classes = names(datasets))
    groups = groupby(datasets,classes[end])
    if length(groups) == 1          # 取出分类标签（好瓜/坏瓜），如果只有一种，不需要继续分割
        return groups[end][end][end]
    end
    if length(classes) == 1         # 没有别的类别可以用来分割，取概率最大的分类标签
        max_group = groups[1]
        for group in groups[2:end-1]
            if length(group) > length(max_group)
                max_group = group
            end
        end
        return max_group[end][end]
    end

    best_class = classes[1]         # 取出最好的分类类别，即信息增益最大的类别
    best_gain = calcGain(datasets,best_class)
    for class in classes[1:end-1]
        curr_gain = calcGain(datasets,class)
        if curr_gain > best_gain
            best_class = class
            best_gain = curr_gain
        end
    end

    new_classes = copy(classes)     # 递归调用，下一个分支需要用到的分类标签
    filter!(x->x!=best_class, new_classes)   # 由于julia传引用，需要拷贝一份
    best_class_label = Set(datasets[best_class])
    tree = Dict(best_class => Dict())

    # 遍历该类别标准下所有子分类，递归求解
    for group in groupby(datasets,best_class)
        tree[best_class][group[best_class][1]] = createTree(group,new_classes)
    end

    return tree
end

# 这里使用的是西瓜书 西瓜数据集2.0
datasets = CSV.read("2.0.csv");
tree = createTree(datasets)
```

[数据集奉上](2.0.csv)!

Todo List:

* 决策树的剪枝
* 决策树可视化
* 决策树的使用
* 决策树的存储

Change List:

* 2018/9/13 : 补充了代码实现