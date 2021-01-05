# 정규 표현식
## R Study
### 2021-01-05

___


> **정규표현식**이란? 
> 문자열에 특정한 규칙이 있는 경우 해당 규칙을 식으로 정의하여 규칙에 맞는 문자열들을 추출할 때 사용하는 기능

> **정규표현식**을 왜 사용하는가? 
> 특정한 조건에 맞는 문자를 추출할 경우 조건문보다 간단하고 효율적. ~간단하다고?~

> **정규표현식** 확인사이트 
> Click [here] (https://regexr.com)
정규표현식을 만들 때 표현식을 입력하면 텍스트에서 패턴이 일치하는 부분을 ___하이라이트___ 또는 *하이라이트* 표시해주어 유용하게 사용할 수 있는 사이트.


```
12345 abcde MINIMI lab 미니미랩
ac abc abbbbbc
ac abc abbc
img src= "minimilab.jpg"
img src = "minimilab.jpg"
img src  = "minimilab.jpg"
img src   = "minimilab.jpg"
010 2937 9987, 02-303-2847, 070-2093-1717
```

- /미니미랩/g  
# //안의 글씨
- /MINIMI/g
- /[0-9]/g     
# 숫자
- /[135]/g     
# 숫자 하나씩
- /[0-9]+/g    
# +는 연속의 의미 #연속된 숫자
- /[\d]+/g     
# [d]=[0-9]
- /[\D]+/g     
# 대문자는 반대 의미
- /[\w]+/g 
# 연속된 문자
- /[\W]+/g  
# 문자 아닌 것들 (한글 포함)
- /[a-z]+/g
- /[A-Z]+/g 
- /[가-힣]+/g 

- /[\s]+/g 
# 공백
- /[a.c]+/g 
# .은 임의의 한 문자
- /[ab?c]+/g 
# ?는 0개 혹은 1개의 문자
- /[ab*c]+/g 
# 0개 혹은 1개 이상의 글자

1. img src[\s]*
# 이 글씨 뒤에 공백이 0개 이거나 1개 이상
2. \d{3,4}
# 숫자가 세개 혹은 네개
3. \d{2,3}[\s-]?\d{3,4}[ -]?\d{4}
# 숫자가 두개 혹은 세개 # 공백이나 하이픈 # ~