//
//  AFURLSessionOperation.h
//
//  Created by Robert Ryan on 12/13/15.
//  Copyright © 2015 Robert Ryan. All rights reserved.
//

#import "AsynchronousOperation.h"
#import <AFNetworking/AFNetworking.h>
@class AFURLSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AFURLSessionOperation : AsynchronousOperation

/** The NSURLSessionTask associated with this operation
 */
@property (nonatomic, strong, readonly, nullable) NSURLSessionTask *task;

/**
 Creates an `NSURLSessionDataTask` with the specified request.
 
 In the spirit of AFNetworking deprecating `dataTaskWithRequest` without `uploadProgress` and `downloadProgress`,
 this also is deprecated. Use `dataOperationWithManager:request:uploadProgress:downloadProgress:completionHandler:`
 instead.
 
 @param manager The AFURLSessionManager for the operation.
 @param request The HTTP request for the request.
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 */
+ (instancetype)dataOperationWithManager:(AFURLSessionManager *)manager
                                 request:(NSURLRequest *)request
                       completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler  DEPRECATED_ATTRIBUTE;

/**
 Creates an `NSURLSessionDataTask` with the specified request.
 
 @param manager The AFURLSessionManager for the operation.
 @param request The HTTP request for the request.
 @param uploadProgress A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param downloadProgress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 */
+ (instancetype)dataOperationWithManager:(AFURLSessionManager *)manager
                                 request:(NSURLRequest *)request
                          uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                        downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                       completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

///---------------------------
/// @name Running Upload Tasks
///---------------------------

/**
 Creates an `NSURLSessionUploadTask` with the specified request for a local file.
 
 @param manager The AFURLSessionManager for the operation.
 @param request The HTTP request for the request.
 @param fileURL A URL to the local file to be uploaded.
 @param progress A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 
 @see `attemptsToRecreateUploadTasksForBackgroundSessions`
 */
- (instancetype)uploadOperationWithManager:(AFURLSessionManager *)manager
                                   request:(NSURLRequest *)request
                                  fromFile:(NSURL *)fileURL
                                  progress:(nullable void (^)(NSProgress *uploadProgress)) progress
                         completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/**
 Creates an `NSURLSessionUploadTask` with the specified request for an HTTP body.
 
 @param manager The AFURLSessionManager for the operation.
 @param request The HTTP request for the request.
 @param bodyData A data object containing the HTTP body to be uploaded.
 @param progress A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 */
+ (instancetype)uploadOperationWithManager:(AFURLSessionManager *)manager
                                   request:(NSURLRequest *)request
                                  fromData:(nullable NSData *)bodyData
                                  progress:(nullable void (^)(NSProgress *uploadProgress)) progress
                         completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/**
 Creates an `NSURLSessionUploadTask` with the specified streaming request.
 
 @param manager The AFURLSessionManager for the operation.
 @param request The HTTP request for the request.
 @param progress A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 */
+ (instancetype)uploadOperationWithManager:(AFURLSessionManager *)manager
                           streamedRequest:(NSURLRequest *)request
                                  progress:(nullable void (^)(NSProgress *uploadProgress)) progress
                         completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

///-----------------------------
/// @name Running Download Tasks
///-----------------------------

/**
 Creates an `NSURLSessionDownloadTask` with the specified request.
 
 @param manager The AFURLSessionManager for the operation.
 @param request The HTTP request for the request.
 @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 @param completionHandler A block to be executed when a task finishes. This block has no return value and takes three arguments: the server response, the path of the downloaded file, and the error describing the network or parsing error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 
 @warning If using a background `NSURLSessionConfiguration` on iOS, these blocks will be lost when the app is terminated. Background sessions may prefer to use `-setDownloadTaskDidFinishDownloadingBlock:` to specify the URL for saving the downloaded file, rather than the destination block of this method.
 */
+ (instancetype)downloadOperationWithManager:(AFURLSessionManager *)manager
                                     request:(NSURLRequest *)request
                                    progress:(nullable void (^)(NSProgress *downloadProgress)) progress
                                 destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 Creates an `NSURLSessionDownloadTask` with the specified resume data.
 
 @param manager The AFURLSessionManager for the operation.
 @param resumeData The data used to resume downloading.
 @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 @param completionHandler A block to be executed when a task finishes. This block has no return value and takes three arguments: the server response, the path of the downloaded file, and the error describing the network or parsing error that occurred, if any.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 */
+ (instancetype)downloadOperationWithManager:(AFURLSessionManager *)manager
                                  resumeData:(NSData *)resumeData
                                    progress:(nullable void (^)(NSProgress *downloadProgress)) progress
                                 destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
