import http.server
import socketserver
import json
import sqlite3
import os

DB_PATH = "/Users/mac/Documents/Project/photobooth/snapbooth.db"

def init_sqlite_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Create Users Table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            username TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            auth_provider TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create Photo Sessions Table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS photo_sessions (
            id TEXT PRIMARY KEY,
            user_email TEXT NOT NULL,
            frame_style TEXT NOT NULL,
            frame_color_hex TEXT NOT NULL,
            strip_format TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    conn.close()
    print(f"[DATABASE SERVER] SQLite Database initialized at {DB_PATH}")

class ReusableTCPServer(socketserver.TCPServer):
    allow_reuse_address = True

class DBHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data.decode('utf-8'))
        
        path = self.path
        response = {"success": False}
        
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        
        try:
            if path == "/api/users/sync":
                user_id = data.get("id")
                name = data.get("name")
                username = data.get("username")
                email = data.get("email")
                provider = data.get("authProvider", "email")
                
                cursor.execute('''
                    INSERT INTO users (id, name, username, email, auth_provider)
                    VALUES (?, ?, ?, ?, ?)
                    ON CONFLICT(email) DO UPDATE SET
                    name=excluded.name, username=excluded.username, auth_provider=excluded.auth_provider
                ''', (user_id, name, username, email, provider))
                conn.commit()
                response = {"success": True, "message": "User saved to SQLite Database", "user": {"id": user_id, "name": name, "username": username, "email": email}}
                
            elif path == "/api/sessions/save":
                session_id = data.get("id")
                email = data.get("email")
                frame_style = data.get("frameStyle")
                frame_color = data.get("frameColorHex", "#FF6FA5")
                format_type = data.get("stripFormat", "4-Cut Strip")
                
                cursor.execute('''
                    INSERT INTO photo_sessions (id, user_email, frame_style, frame_color_hex, strip_format)
                    VALUES (?, ?, ?, ?, ?)
                ''', (session_id, email, frame_style, frame_color, format_type))
                conn.commit()
                response = {"success": True, "message": "Photo session saved to SQLite Database"}
                
        except Exception as e:
            response = {"success": False, "error": str(e)}
            
        conn.close()
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(response).encode('utf-8'))

if __name__ == "__main__":
    init_sqlite_db()
    PORT = 8086
    with ReusableTCPServer(("", PORT), DBHandler) as httpd:
        print(f"Database REST API Server running at http://localhost:{PORT}")
        httpd.serve_forever()
