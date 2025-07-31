package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import receite.me.auth.AuthenticationRequest;
import receite.me.auth.RegisterRequest;
import receite.me.service.AuthenticationService;
import receite.me.factory.ProblemFactory;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthenticationController {
    private final AuthenticationService authenticationService;
    private final ProblemFactory problemFactory;

    @PostMapping("/create")
    public ResponseEntity<?> create(@RequestBody RegisterRequest request){
        try {
            return ResponseEntity.ok(authenticationService.register(request));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createProblem(e.getMessage(), HttpStatus.BAD_REQUEST));
        }
    }

    @PostMapping("/authenticate")
    public ResponseEntity<?> authenticate(@RequestBody AuthenticationRequest request){
        try {
            return ResponseEntity.ok(authenticationService.authenticate(request));
        }
        catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createProblem(e.getMessage(), HttpStatus.BAD_REQUEST));
        }
    }
    
    @PostMapping("/passwordConfirmation")
    public ResponseEntity<?> passwordConfirmation(@RequestBody AuthenticationRequest request){
        try {
            return ResponseEntity.ok(authenticationService.confirm(request));
        }
        catch (Exception e) {
            return ResponseEntity.badRequest().body(false);
        }
    }
}
