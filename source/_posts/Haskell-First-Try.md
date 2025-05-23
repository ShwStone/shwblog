---
abbrlink: ''
categories: []
date: '2025-03-31T23:58:07.225303+08:00'
sticky: 11
tags: []
title: Haskell First Try
updated: '2025-03-31T23:58:08.622+08:00'
---
前两天看到了 lambda 算子，觉得这玩意真优雅，决定学一些 Haskell。

<!--more-->

在简单了解了 `data` 和 `List` 之后，觉得自己行了，就写了一个 AVL。

关于什么是 AVL，左转 [OI-wiki](https://oi-wiki.org/ds/avl/)。

这个语言很适合做数据结构的教学，非常非常非常接近伪代码，不用操心什么细节。即使是完全没有接触过 Haskell 的人，看到代码也能对逻辑了解个大概，除了 `Maybe` 和 `IO` 之类的魔法之外都很容易理解。

但是写这个非常累，可能我没什么函数式思想，写了整整一天。但是最终的结果（在我看来）非常优雅，目前的可扩展性也很强，只要改一改 `Info` 就可以维护更多信息。

因为还没有看 Manod 和 IO 之类的，所以输入输出是凭感觉写的，可能会有更简洁的实现，或者更快的实现。给我的感觉是，在 do 的语法糖帮助下，跟写 shell 差不多，不过每一行都得调用 IO 函数，不能直接调纯函数（确实也没啥意义）。

直接看看代码，注释很详细：

```haskell
type Info = (Int, Int)

empty = (0, 0) :: Info

data Tree a = Empty | (Ord a) => Node (Tree a) a Info (Tree a)

-- 只是为了通过 luogu 模板题，是没必要使用 Maybe 的，但这里还是做了简单的错误处理。为了方便，定义一个函数来解包正常的 Maybe
-- 简单解释 Maybe a :: Nothing | Just a

just :: Maybe a -> a
just (Just a) = a

height :: Tree a -> Int -- 得到子树高度
height Empty = 0
height (Node _ _ (h, _) _) = h

size :: Tree a -> Int -- 得到子树大小
size Empty = 0
size (Node _ _ (_, s) _) = s

maintainInfo :: Tree a -> Tree a -- 维护高度和大小
maintainInfo (Node ls value _ rs) = Node ls value (max (height ls) (height rs) + 1, size ls + size rs + 1) rs

rotateL :: Tree a -> Tree a -- 左单旋
rotateL (Node (Node ll lv _ lr) value _ rs) =
  maintainInfo (Node ll lv empty (maintainInfo (Node lr value empty rs)))

rotateR :: Tree a -> Tree a -- 右单旋
rotateR (Node ls value _ (Node rl rv _ rr)) =
  maintainInfo (Node (maintainInfo (Node ls value empty rl)) rv empty rr)

-- 若 height ls > height rs + 1，则 height ls >= 2，ls 与 (ll或lr) 必然不为 Empty

rotateL_ :: Tree a -> Tree a -- 左旋（可能双旋）
rotateL_ (Node (Node ll lv _ lr) value _ rs)
  | height ll >= height lr = rotateL (Node (Node ll lv empty lr) value empty rs)
  | otherwise = rotateL (Node (rotateR (Node ll lv empty lr)) value empty rs)

rotateR_ :: Tree a -> Tree a -- 右旋（可能双旋）
rotateR_ (Node ls value _ (Node rl rv _ rr))
  | height rl > height rr = rotateR (Node ls value empty (rotateL (Node rl rv empty rr)))
  | otherwise = rotateR (Node ls value empty (Node rl rv empty rr))

maintain :: Tree a -> Tree a -- 维护信息和平衡
maintain (Node ls value info rs)
  | height ls > height rs + 1 = rotateL_ (Node ls value info rs)
  | height rs > height ls + 1 = rotateR_ (Node ls value info rs) -- 旋转内部必然维护了 Info
  | otherwise = maintainInfo (Node ls value info rs) -- 不旋转需要单独维护 Info

insert :: (Ord a) => a -> Tree a -> Tree a
insert x Empty = Node Empty x (1, 1) Empty -- 从空树开始插入
insert x (Node ls value _ rs) -- 很普通的搜索树插入，只是多做一次 maintain
  | x < value = maintain (Node (insert x ls) value empty rs)
  | x >= value = maintain (Node ls value empty (insert x rs))

iter :: Tree a -> [a] -- 中序遍历（其实前序遍历才是开销最低的）
iter Empty = []
iter (Node ls value _ rs) = iter ls ++ [value] ++ iter rs

maxi :: Tree a -> Maybe a -- 最大值（可能不存在）
maxi Empty = Nothing
maxi (Node _ value _ Empty) = Just value
maxi (Node _ _ _ rs) = maxi rs

mini :: Tree a -> Maybe a -- 最小值（可能不存在）
mini Empty = Nothing
mini (Node Empty value _ _) = Just value
mini (Node ls _ _ _) = mini ls

eraseSwap :: Tree a -> Tree a -- 将子树根节点删除
eraseSwap Empty = Empty
eraseSwap (Node ls _ _ Empty) = ls -- 如果只有一个儿子，直接删除
eraseSwap (Node ls _ _ rs) =
  let next = just (mini rs) -- 否则求出根的后继，因为必然存在，所以用 just 解包
   in maintain (Node ls next empty (erase next rs)) -- 把后继作为新根，把原来的后继删除

erase :: a -> Tree a -> Tree a -- 很普通的搜索树删除，只是多做一次 maintain
erase _ Empty = Empty
erase x (Node ls value _ rs)
  | x < value = maintain (Node (erase x ls) value empty rs)
  | x > value = maintain (Node ls value empty (erase x rs))
  | x == value = eraseSwap (Node ls value empty rs)

-- 下面都是很普通的搜索树操作 --

next :: a -> Tree a -> Maybe a -- 后继（可能不存在）
next _ Empty = Nothing
next x (Node ls value _ rs)
  | x < value = Just (maybe value (min value) (next x ls))
  | x >= value = next x rs

prev :: a -> Tree a -> Maybe a -- 前驱（可能不存在）
prev _ Empty = Nothing
prev x (Node ls value _ rs)
  | x <= value = prev x ls
  | x > value = Just (maybe value (max value) (prev x rs))

rank :: a -> Tree a -> Int -- 查询排名（小于 x 的节点数 +1）
rank _ Empty = 1
rank x (Node ls value _ rs)
  | x <= value = rank x ls
  | x > value = size ls + 1 + rank x rs

select :: Int -> Tree a -> Maybe a -- 按照排名查询值（可能不存在）
select _ Empty = Nothing
select k (Node ls value _ rs)
  | size ls >= k = select k ls
  | size ls == k - 1 = Just value
  | otherwise = select (k - size ls - 1) rs

-- AVL tree 就全部写完了 --

update :: [Int] -> Tree Int -> Tree Int
update [1, x] = insert x
update [2, x] = erase x

ask :: [Int] -> Tree Int -> Int
ask [3, x] tree = rank x tree
ask [4, x] tree = just (select x tree)
ask [5, x] tree = just (prev x tree)
ask [6, x] tree = just (next x tree)

solve :: Int -> Tree Int -> IO ()
solve 0 _ = return ()
solve n tree = do
  inputQuery <- getLine
  let l = map read (words inputQuery) :: [Int]
  if head l < 3
    then do
      solve (n - 1) (update l tree)
    else do
      print (ask l tree)
      solve (n - 1) tree
  return ()

main :: IO ()
main = do
  inputN <- getLine
  let n = read inputN :: Int
  solve n Empty
  return ()

-- https://www.luogu.com.cn/record/211234224
```

开销非常大，加在一起跑了两秒钟，应该来说，因为数据是不可变的，所有的修改都是复制构造，做数据结构确实是慢一些。

看看数据加强版？

通过增加一些屎山实现强制在线：

```haskell
update :: [Int] -> Int -> Tree Int -> Tree Int
update [1, x] lastAns = insert (xor x lastAns)
update [2, x] lastAns = erase (xor x lastAns)

ask :: [Int] -> Int -> Tree Int -> Int
ask [3, x] lastAns tree = rank (xor x lastAns) tree
ask [4, x] lastAns tree = just (select (xor x lastAns) tree)
ask [5, x] lastAns tree = just (prev (xor x lastAns) tree)
ask [6, x] lastAns tree = just (next (xor x lastAns) tree)

solve :: Int -> Tree Int -> Int -> Int -> IO ()
solve 0 _ lastAns xorAns = print xorAns
solve n tree lastAns xorAns = do
  inputQuery <- getLine
  let l = map read (words inputQuery) :: [Int]
  if head l < 3
    then do
      solve (n - 1) (update l lastAns tree) lastAns xorAns
    else do
      let ans = ask l lastAns tree
      solve (n - 1) tree ans (xor xorAns ans)
  return ()

inserts :: [Int] -> Tree Int -> Tree Int 
inserts xs tree = foldl (flip insert) tree xs

main :: IO ()
main = do
  inputNM <- getLine
  let l = map read (words inputNM) :: [Int]
  let n = head l
  let m = last l
  inputX <- getLine
  let xs = map read (words inputX) :: [Int]
  solve m (inserts xs Empty) 0 0
  return ()
```

结果如何呢？MLE！

事实上，这一份代码的内存占用十分恐怖，原题就使用了 40+ MB，相比之下，使用 `std::vector` 暴力 `insert` 只用了不到 1 MB，还只要 250 ms。

这是亟待解决的问题。Haskell 是否能够编写出更贴近 native 的代码？是否要为此提高抽象程度？我将会继续学习这个部分。



