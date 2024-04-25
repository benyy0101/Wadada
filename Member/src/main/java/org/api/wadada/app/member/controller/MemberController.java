//package org.api.wadada.app.member.controller;
//
//
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;
//import org.api.wadada.app.member.controller.dto.MemberDuplicationRequestDto;
//import org.api.wadada.app.member.controller.dto.MemberSigninRequestDto;
//import org.api.wadada.app.member.controller.dto.MemberUpdateRequestDto;
//import org.api.wadada.app.member.entity.Member;
//import org.api.wadada.app.member.service.MemberService;
//import org.api.wadada.error.errorcode.CommonErrorCode;
//import org.api.wadada.error.exception.RestApiException;
//import org.api.wadada.service.S3UploadService;
//import org.api.wadada.util.MemberUtil;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/member")
//@RequiredArgsConstructor
//@Slf4j
//public class MemberController {
//
//    private final MemberService memberService;
//    private final S3UploadService s3UploadService;
//
//    @PostMapping("")
//    public ResponseEntity<String> signup(@RequestBody @Valid MemberSigninRequestDto req){
//        req.setRoles(List.of("USER"));
//        Member created = memberService.create(req);
//        return ResponseEntity.ok(created.getMemberId());
//    }
//
//    @PatchMapping("")
//    public ResponseEntity<Void> update(@Valid @RequestBody MemberUpdateRequestDto req) {
//        String memberId = MemberUtil.getMemberId();
//        memberService.update(req, memberId);
//        return ResponseEntity.ok().build();
//    }
//
//    @DeleteMapping("")
//    public ResponseEntity<Void> delete(){
//        String memberId = MemberUtil.getMemberId();
//        memberService.delete(memberId);
//        return ResponseEntity.ok().build();
//    }
//
//    @GetMapping("/check")
//    public ResponseEntity<Boolean> duplicationValidate(@Valid MemberDuplicationRequestDto req){
//        if(req.isAllNull()) throw new RestApiException(CommonErrorCode.WRONG_REQUEST);
//        return ResponseEntity.ok(memberService.duplicationValid(req));
//    }
//
//    @GetMapping("/{memberId}")
//    public ResponseEntity<MemberDetailResponseDto> get(@PathVariable String memberId){
//        return ResponseEntity.ok(memberService.getMemberDetail(memberId));
//    }
//
//}
