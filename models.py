from sqlalchemy import Column, Integer, String, Text
from database import Base

# Define the Resume model
class Resume(Base):
    __tablename__ = "resumes"

    id = Column(Integer, primary_key=True, index=True)
    job_title = Column(String, index=True)
    skills = Column(Text)
    experience = Column(Text)
    pinata_url = Column(String, nullable=True)
