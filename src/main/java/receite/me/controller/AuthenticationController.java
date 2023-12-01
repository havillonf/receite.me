package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import receite.me.auth.AuthenticationRequest;
import receite.me.auth.RegisterRequest;
import receite.me.model.Problem;
import receite.me.service.AuthenticationService;

import java.time.LocalDateTime;

import static org.springframework.http.ResponseEntity.created;
import static org.springframework.web.servlet.support.ServletUriComponentsBuilder.fromCurrentRequest;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthenticationController {
    private final AuthenticationService authenticationService;

    @PostMapping("/create")
    public ResponseEntity<?> create(@RequestBody RegisterRequest request){
        try {
            return ResponseEntity.ok(authenticationService.register(request));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }

    @PostMapping("/authenticate")
    public ResponseEntity<?> authenticate(@RequestBody AuthenticationRequest request){
        try {
            return ResponseEntity.ok(authenticationService.authenticate(request));
        }
        catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }
}
