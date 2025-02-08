from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import requests
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

OLLAMA_API_KEY = os.getenv("OLLAMA_API_KEY")
PINATA_API_KEY = os.getenv("PINATA_API_KEY")
PINATA_SECRET_API_KEY = os.getenv("PINATA_SECRET_API_KEY")

# Initialize FastAPI app
app = FastAPI()

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Update this for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Endpoints
@app.post("/generate-resume")
async def generate_resume(request: Request):
    data = await request.json()
    job_title = data.get("jobTitle")
    skills = data.get("skills", [])
    experience = data.get("experience")

    if not job_title or not skills or not experience:
        return JSONResponse(status_code=400, content={"error": "Missing required fields"})

    try:
        response = requests.post(
            "https://api.ollama.ai/v1/generate",
            json={
                "prompt": f"Generate a professional resume:\n"
                          f"Job Title: {job_title}\n"
                          f"Skills: {', '.join(skills)}\n"
                          f"Experience: {experience}"
            },
            headers={"Authorization": f"Bearer {OLLAMA_API_KEY}"}
        )

        if response.status_code == 200:
            resume_content = response.json().get("generated_text", "")
            return {"resumeContent": resume_content}
        else:
            return JSONResponse(status_code=500, content={"error": "Failed to generate resume"})
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})


@app.post("/upload-resume")
async def upload_resume(request: Request):
    data = await request.json()
    resume_content = data.get("resumeContent")
    file_name = data.get("fileName", "resume")

    if not resume_content:
        return JSONResponse(status_code=400, content={"error": "Resume content is required"})

    try:
        file_path = f"./{file_name}.html"
        with open(file_path, "w") as file:
            file.write(resume_content)

        with open(file_path, "rb") as file:
            response = requests.post(
                "https://api.pinata.cloud/pinning/pinFileToIPFS",
                files={"file": file},
                headers={
                    "pinata_api_key": PINATA_API_KEY,
                    "pinata_secret_api_key": PINATA_SECRET_API_KEY
                }
            )

        if response.status_code == 200:
            ipfs_hash = response.json().get("IpfsHash")
            pinata_url = f"https://gateway.pinata.cloud/ipfs/{ipfs_hash}"
            return {"ipfsHash": ipfs_hash, "pinataUrl": pinata_url}
        else:
            return JSONResponse(status_code=500, content={"error": "Failed to upload to Pinata"})
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

# Run the application
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
