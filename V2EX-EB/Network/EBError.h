//
//  EBError.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#ifndef EBError_h
#define EBError_h

typedef NS_ENUM(int, EBErrorCode) {
    EBErrorCodeUndefined = 1024,
    EBErrorCodeInvalidArguments = 1025,
    EBErrorCodeLoginFailed = 1026,
    EBErrorCodeHackSecurityInformationError = 1027
};

#endif /* EBError_h */
