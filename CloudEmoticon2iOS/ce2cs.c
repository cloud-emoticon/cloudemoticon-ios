//
//  ce2cs.c
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/6/22.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define kP "CloudEmoticon2iOS-SDKAPIKey"
char* enc(char* source, char* pass)
{
    unsigned long source_length = strlen(source);
    unsigned long pass_length = strlen(pass);
    char* tmp_str = (char*)malloc((source_length + 1) * sizeof(char));
    memset(tmp_str, 0, source_length + 1);
    for(int i = 0; i < source_length; ++i)
    {
        tmp_str[i] = source[i]^pass[i%pass_length];
        if(tmp_str[i] == 0)
        {
            tmp_str[i] = source[i];
        }
    }
    tmp_str[source_length] = 0;
    return tmp_str;
}
char* parse_applicationid()
{
    return enc("/=qW\\f4\"#\n\n	??(=", kP);
}
char* parse_clientkey()
{
    return enc("+.!Y,\n->a\n|ov%(,}726Y2,m0\n#>", kP);
}
char* mobclick()
{
    return enc("vYWB|[\nB^ZVW~`ctzx5+", kP);
}