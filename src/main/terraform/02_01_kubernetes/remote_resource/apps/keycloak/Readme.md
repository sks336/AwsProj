

1. Create realm **myrealm**
2. Create clients **client1/client2**
3. Create roles inside those clients
4. Create multiple users e.g. **u1, u2, u3 etc** and assign the client roles under role mapping for these users


- ###For Client credential flow, retrieve the access toekn
curl -X POST "http://kube.techlearning.me:32100/realms/myrealm/protocol/openid-connect/token" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "grant_type=client_credentials" \
-d "client_id=client1" \
-d "client_secret=<CLIENT_SECRET>"



- ###For Standard flow, retrieve the access toekn by hitting below in the browser
http://kube.techlearning.me:32100/realms/myrealm/protocol/openid-connect/auth?client_id=client1&response_type=code&scope=openid&redirect_uri=http://localhost/callback


##### The response would look similar to this
http://localhost/callback?session_state=3f3d1fc0-3f21-44cd-b8c7-8120a5c762f2&iss=http%3A%2F%2Fkube.techlearning.me%3A32100%2Frealms%2Ftest&code=f47cc5c7-0f2f-4c39-af86-edabe138962e.3f3d1fc0-3f21-44cd-b8c7-8120a5c762f2.8f18a964-69c5-46f9-b9f5-dc8b76fb8c16





###Use the code to get the access token
curl -X POST "http://kube.techlearning.me:32100/realms/myrealm/protocol/openid-connect/token" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "grant_type=authorization_code" \
-d "code=a37ceddd-3cd3-4de1-8fe2-1508e4d2916f.3f3d1fc0-3f21-44cd-b8c7-8120a5c762f2.8f18a964-69c5-46f9-b9f5-dc8b76fb8c16" \
-d "client_id=client1" \
-d "client_secret=<CLIENT_SECRET>" \
-d "redirect_uri=http://localhost/callback"