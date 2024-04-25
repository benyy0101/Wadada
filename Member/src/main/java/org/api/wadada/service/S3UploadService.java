package org.api.wadada.service;


import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class S3UploadService {

    private final AmazonS3 amazonS3;
    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String saveFile(MultipartFile multipartFile, String path) {
        try {
            String originalName = multipartFile.getOriginalFilename();
            String pureFileName = originalName.split("\\.")[0];
            String extension = "." + originalName.split("\\.")[1];
            String filename = pureFileName + LocalDateTime.now() + extension;

            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(multipartFile.getSize());
            metadata.setContentType(multipartFile.getContentType());

            amazonS3.putObject(bucket, path + filename, multipartFile.getInputStream(), metadata);
            return amazonS3Client.getUrl(bucket, path + filename).toString();
        } catch (IOException e){
            throw new RestApiException(CommonErrorCode.INTERNAL_SERVER_ERROR, "이미지 파일 업로드 중 오류가 발생하였습니다");
        }
    }

    public void deleteImage(String url, String path)  {
        String decodedUrl = URLDecoder.decode(url, StandardCharsets.UTF_8);
        String key = path + decodedUrl.split("/")[5];
        log.info("{}", key);
        try{
            amazonS3.deleteObject(bucket, key);
        } catch (AmazonServiceException e){
            throw new RestApiException(CommonErrorCode.INTERNAL_SERVER_ERROR, "파일 삭제 과정에 에러가 발생하였습니다");
        }
    }
}