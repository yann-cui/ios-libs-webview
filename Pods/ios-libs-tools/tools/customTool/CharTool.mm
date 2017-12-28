//
//  CharTool.m
//  gezilicai
//
//  Created by 7heaven on 16/3/8.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#include "CharTool.h"
#include <map>
#include <string>

using namespace std;

static const map<int, string> charMap =
{{1, "一"}, {2, "二"}, {3, "三"}, {4, "四"}, {5, "五"}, {6, "六"}, {7, "七"},
    {8, "八"}, {9, "九"}, {10, "十"}, {100, "百"}, {1000, "千"}, {10000, "万"}, {100000, "十万"}, {1000000, "百万"}, {10000000, "千万"}, {100000000, "亿"}};

const string& num2Chinese(int num, string &cn) {
    int n = num, pre = 0;
    
    //从map最后一个开始遍历。(10000->1000->100)这样可以让字符串从数字的最高位开始加字符
    for (auto it = charMap.crbegin(); it != charMap.crend(); ++it) {
        int count = 0;
        
        // ------- count == 0 的时候  跳过下面的步骤 进入下一次的循环(continue;)
        // |       sample:
        // |       step 1: num = 1024; n = num; (n = 1024)
        // |       step 2: n > 1000;  n -= 1000 (n = 24) count = 1;  这边符合下面"if(it->first >= 10 && (count != 1 || num > 20))"的情况，
        // |               cn += map.at(count) 这边是"一"  (cn = "一")
        // |               cn += it->second 这边是"千" (cn = "一千")
        // |               pre记录为1000
        // |       step 3: n > 10; n -= 10 (n = 14) n > 10; n -= 10 (n = 4) count = 2
        // |               这边符合"if(pre / 10 > it->first)"的情况 cn += "零" (cn = "一千零")
        // |               符合"if(it->first >= 10 && (count != 1 || num > 20))"的情况 cn += map.at(count) 这边是"二" (cn = "一千零二")
        // |               cn += it->second 这边是"十" (cn = "一千零二十")
        // |       step 4: n > 4; n -= 4 (n = 0) count = 1
        // |               这里已经不符合"if(it->first >= 10 && (count != 1 || num > 20))"的情况  跳过
        // |               cn += it->second 这边是"四" (cn = "一千零二十四")
        // |
        // |
        // |
        // |    //让n从map里面最大的数值开始减少 并借此确定某一位的数值大小(用count来储存)
        /* | */ for ( ; n >= it->first; n -= it->first) ++count;
        // |    //当前位是0  跳过
        /* -> */if (!count) continue;
        //上一次记录的数值pre / 10 以后 依然大于当前的数值  说明和上一次已经相差了不止一位  表示中间有0  cn += "零"
        if (pre / 10 > it->first) cn += "零";
        //这边it->first >= 10表示属于"十"，"百"，"千"，"万"其中一个 如果count != 1(就是count > 1)需要在前面的字符加上对应位的数(比如"千" 前面加上"二"  = "两千") 后面再加一个num > 20 是因为如果 数值大于两位 (比如100 1000)这时候就算count == 1前面也是需要加上"一"的
        if (it->first >= 10 && (count != 1 || num > 20)) cn += charMap.at(count);
        
        //正常的加上当前的值
        cn += it->second;
        //记录作为下一次判断用
        pre = it->first;
    }
    return cn;
}

const static int F_MOD = 11;
const static int OLD_LEN = 15;
const static int NEW_LEN = 18;
const static std::string CHECK_CODE = "10X98765432";

const static int LOCAL[35] = {11, 12, 13, 14, 15, 21, 22, 23, 31, 32, 33, 34, 35, 36, 37, 41, 42, 43, 44, 45, 46, 50, 51, 52, 53, 54, 60, 61, 62, 63, 64, 65, 71, 81, 82};
const static int WEIGHT[17] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};

//二分查找
int bSearch(int target, const int array[], int length){
    int first = 0;
    int last = length - 1;
    int middle = (first + last) / 2;
    
    int match = -1;
    
    while (first <= last) {
        if (array[middle] < target)
            first = middle + 1;
        else if (array[middle] == target) {
            match = middle;
            break;
        }
        else
            last = middle - 1;
        
        middle = (first + last) / 2;
    }
    
    return match;
}

//身份证长度检测
int checkLength(const std::string &cardNumber){
    size_t length = cardNumber.length();
    
    return length == OLD_LEN || length == NEW_LEN;
}

//身份证地区检测
int checkLocal(const std::string &cardNumber){
    int localNum = (cardNumber[0] - 48) * 10 + (cardNumber[1] - 48);
    
    return bSearch(localNum, LOCAL, 35) != -1;
}

//身份证最后一位校验
int checkCode(const std::string &cardNumber){
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        sum += (cardNumber[i] - 48) * WEIGHT[i];
    }
    char iCode = (char) (sum % F_MOD);
    char check = CHECK_CODE.at(iCode);
    return check == cardNumber[17];
}

int isNew(const std::string &cardNumber){
    return cardNumber.length() == NEW_LEN;
}


//检测身份证号的正确性
int checkIdentityCard(const std::string &cardNumber){
    return checkLength(cardNumber) && checkLocal(cardNumber) && ((isNew(cardNumber) && checkCode(cardNumber)) || !isNew(cardNumber));
}

NSArray * allRangesOfString(NSString *substring, NSString *string){
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0,string.length);
    NSRange foundRange;
    while (searchRange.location < string.length) {
        searchRange.length = string.length-searchRange.location;
        foundRange = [string rangeOfString:substring options:0 range:searchRange];
        if (foundRange.location != NSNotFound) {
            [ranges addObject:[NSValue valueWithRange:foundRange]];
            // found an occurrence of the substring! do stuff here
            searchRange.location = foundRange.location+foundRange.length;
        } else {
            // no more substring to find
            break;
        }
    }
    
    return ranges;
}

NSDictionary * getUrlParams(NSString * url){
    
    //获取url中最外层的引号
    std::map<int, int> pairs;
    
    const unsigned long urlLength = [url length];
    unsigned char * got = (unsigned char *)malloc(urlLength * sizeof(unsigned char));
    int * gotIndex = (int *) malloc(urlLength * sizeof(int));
    memset(got, 0, sizeof(unsigned char) * urlLength);
    memset(gotIndex, 0, sizeof(int) * urlLength);
    int gotCursor = 0;
    //遍历url找到所有单引号和双引号的pair，并放入pairs map内(这个过程会忽略引号嵌套，只取最外层)
    for(int i = 0; i < urlLength; i++){
        const unsigned char c = [url characterAtIndex:i];
        if(c == '\'' || c == '\"'){
            if(got[gotCursor - 1] == c){
                gotCursor--;
                
                //gotCursor为零则表示已经找到最外层引号的pair,存入pairs中
                if(gotCursor == 0){
                    pairs[gotIndex[gotCursor]] = i + 1;
                }
            }else{
                got[gotCursor] = c;
                gotIndex[gotCursor] = i;
                
                gotCursor++;
            }
        }
    }
    
    free(got);
    free(gotIndex);
    
    //把引号内容替换掉，以方便做参数的拆分
    NSMutableString *replacedUrl = [url mutableCopy];
    for (auto it = pairs.crbegin(); it != pairs.crend(); ++it) {
        char *replaceChars =  (char *) malloc(it->second - it->first + 1);
        memset(replaceChars, '0', sizeof(char) * it->second - it->first);
        replaceChars[it->second - it->first] = '\0';
        [replacedUrl replaceCharactersInRange:NSMakeRange(it->first, it->second - it->first) withString:[NSString stringWithCString:replaceChars encoding:NSUTF8StringEncoding]];
    }
    
    NSRange rangeOfQuestionMark = [replacedUrl rangeOfString:@"?" options:NSBackwardsSearch];
    
    //根据替换后的url查找需要拆分的位置，并对原始url进行拆分
    if(rangeOfQuestionMark.location != NSNotFound){
        NSString *replacedQuery = [replacedUrl substringFromIndex:rangeOfQuestionMark.location + 1];
        NSString *query = [url substringFromIndex:rangeOfQuestionMark.location + 1];
        
        NSArray *allRangesOfAndMark = allRangesOfString(@"&", replacedQuery);
        if(allRangesOfAndMark && allRangesOfAndMark.count > 0){
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            
            for(int i = 0; i <= allRangesOfAndMark.count; i++){
                if(i < allRangesOfAndMark.count){
                    NSRange range = [allRangesOfAndMark[i] rangeValue];
                    NSString *replacedPair = [replacedQuery substringToIndex:range.location];
                    NSString *pair = [query substringToIndex:range.location];
                    NSRange equalMarkRange = [replacedPair rangeOfString:@"="];
                    
                    if(equalMarkRange.location != NSNotFound){
                        [result setObject:[pair substringFromIndex:equalMarkRange.location + 1] forKey:[pair substringToIndex:equalMarkRange.location]];
                    }
                }else{
                    NSRange range = [allRangesOfAndMark[allRangesOfAndMark.count - 1] rangeValue];
                    NSString *replacedPair = [replacedQuery substringFromIndex:range.location + 1];
                    NSString *pair = [query substringFromIndex:range.location + 1];
                    NSRange equalMarkRange = [replacedPair rangeOfString:@"="];
                    
                    if(equalMarkRange.location != NSNotFound){
                        [result setObject:[pair substringFromIndex:equalMarkRange.location + 1] forKey:[pair substringToIndex:equalMarkRange.location]];
                    }
                }
            }
            
            return result;
        }
    }
    
    return nil;
}

@implementation CharTool

+ (BOOL) checkIdentityCard:(NSString *) cardNumber{
    return checkIdentityCard(std::string([cardNumber UTF8String]));
}

+ (NSString *) num2ChineseNS:(int) num{
    string resultStr;
    num2Chinese(num, resultStr);
    
    return [NSString stringWithCString:resultStr.c_str() encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *) getUrlParams:(NSString *) urlString{
    return getUrlParams(urlString);
}

@end