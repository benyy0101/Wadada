package org.api.wadada.app.member.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.app.member.Service.MemberService;
import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;
import org.api.wadada.app.member.controller.dto.MemberDuplicationVaildResponseDto;
import org.api.wadada.app.member.controller.dto.MemberUpdateRequestDto;
import org.api.wadada.auth.controller.dto.LoginReqeustDto;
import org.api.wadada.auth.controller.dto.LoginResponseDto;
import org.api.wadada.auth.service.OAuthService;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.util.MemberUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/profile")
@RequiredArgsConstructor
@Slf4j
public class MemberController {
    private final MemberService memberService;
    @DeleteMapping("")
    public ResponseEntity<String> delete(){
        String memberId = MemberUtil.getMemberId();
        memberService.deleteMember(memberId);
        return ResponseEntity.ok("delete");
    }
    @PatchMapping("")
    public ResponseEntity<MemberUpdateRequestDto> update(@Valid @RequestBody MemberUpdateRequestDto req) {
        String memberId = MemberUtil.getMemberId();
        memberService.update(req, memberId);
//        return ResponseEntity.ok("update");
        return ResponseEntity.ok(req);
    }

    @GetMapping("")
    public ResponseEntity<MemberDetailResponseDto> get(){
        String memberId = MemberUtil.getMemberId();
        return ResponseEntity.ok(memberService.getMemberDetail(memberId));
    }

    @GetMapping("{nickname}")
    public ResponseEntity<MemberDuplicationVaildResponseDto> duplicationValidate(@Valid @PathVariable("nickname") String memberNickName){
        return ResponseEntity.ok(memberService.duplicationValid(memberNickName));
    }


}
