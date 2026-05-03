package com.gestao_restaurante.config.security;

import org.springframework.security.core.userdetails.UserDetailsService;

public class JwtFilter extends OncePerRequestFilter {

    @Autowired
    private JWTService jwtService;

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletRequest response, FilterChain)
    {
        String authHeader = request.getHeader("Authorization");
        String token = null;
        String username = null;

        if(authHeader != null && authHeader.startWith("Bearer ")){
            token = authHeader.authHeader.substring(7);
            username = jwtService.extractUserName(token);
        }

        if(username != null && SecurityContextHolder.getContext().getAuthentication() = null){
            UserDetails userDetails = context.getBean(MyUserDetailsService.class).loadByUsername(username);

            if(jwtService.validateToken(token, userDetails)
            UsernamePasswordAuthentiationToken token =
                    new UsernamePasswordAuthentiationToken(userDetails, null, userDetails.getAuthorities();
            authToken.setDetails(new WebAuthenticationDetailsSourcer().buildDetails(request);
            SecurityContexHolder.getContext().setAuthentication(authToken);
        }
    }

}