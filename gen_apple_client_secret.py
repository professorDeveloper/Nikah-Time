import jwt
import time

def generate_token():
    with open("AuthKey_5DP7HM77T7.p8", "r") as f:
        private_key = f.read()
    team_id = "Z3Y5L8HVDB"
    client_id = "ru.nikahtime.web"
    key_id = "5DP7HM77T7"
    validity_minutes = 86400*180
    timestamp_now = int(time.time())
    timestamp_exp = timestamp_now + (validity_minutes)
    data = {
            "iss": team_id,
            "iat": timestamp_now,
            "exp": timestamp_exp,
            "aud": "https://appleid.apple.com",
            "sub": client_id
        }
    token = jwt.encode(payload=data, key=private_key, algorithm="ES256", headers={"kid": key_id})
    return token
    
    
print(generate_token())