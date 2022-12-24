# Logic-Gate-Design-using-FPGA


### Latch: 以輸入信號的位準觸發記憶狀態改變，可以用兩個 NOR 閘來建構, 稱為 NOR Latch,  Active high 邏輯 (high 啟動) 電栓, 亦即高態時設置(set, Q=1) 或重設 (reset, /Q=1)

### flip-flop : 以輸入信號的變化 (上升下降) 觸發記憶狀態改變，觸發 flip-flop 記憶狀態改變的信號被稱為 clock (時鐘信號)。

## Clocked D Latch

 ![Screenshot 2022-12-11 133041](https://user-images.githubusercontent.com/68816726/206888094-4005ca8a-9dd0-4406-b36d-09051edbbbcd.png)

## Edge-triggered D Flip-Flops

![圖片](https://user-images.githubusercontent.com/68816726/206888110-a78d0906-e7b0-48f8-a999-dadd82bb90b4.png)

![圖片](https://user-images.githubusercontent.com/68816726/206888138-d1510cb3-fbc2-4905-81d8-1788613ede77.png)


實際燒到FPGA板上，紅色箭頭為Clock，橘色為D

當D為high(將switch打開)時，LED會在Clock為high時亮起
![IMG_0544](https://user-images.githubusercontent.com/68816726/206888295-026d9aa8-19b5-4bfe-b590-d5794b8c317f.jpg)


## Counter:

## Binary ripple up counter

using J-K Flip-Flop

![圖片](https://user-images.githubusercontent.com/68816726/206888533-4e70c62a-d51a-47ab-87e6-0ef42e7f30fb.png)

![圖片](https://user-images.githubusercontent.com/68816726/206888538-84362aee-938f-4e27-b1c7-0c83dafeb3ec.png)

## Ring counter

![圖片](https://user-images.githubusercontent.com/68816726/206888581-ec5634e2-4e3b-416f-b121-eb28cd55b44f.png)


![圖片](https://user-images.githubusercontent.com/68816726/206888564-335ca55c-f649-492d-a159-ac52add2b7aa.png)

FPGA板實現:LED會由右至左依序亮起並不斷重複

(由右至左依序為Q0、Q1、Q2、Q3)

按下按鈕可Reset(重新開始計數)




![IMG_0542](https://user-images.githubusercontent.com/68816726/206888596-c7b58f24-6b98-4f5a-a75e-949c8d749323.jpg)

