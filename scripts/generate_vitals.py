import random
import json
import time
from datetime import datetime, timedelta

def generate_patient_vitals(patient_id):
    """
    Generates a set of synthetic vitals for a specific patient.
    """
    # Realistic ranges for healthy vs unhealthy
    heart_rate = random.randint(60, 100)
    systolic = random.randint(110, 140)
    diastolic = random.randint(70, 90)
    spo2 = random.randint(95, 100)
    temp = round(random.uniform(36.1, 37.5), 1)
    
    # Introduce some "alerts" occasionally
    if random.random() < 0.1:
        heart_rate = random.randint(110, 140)  # Tachycardia
    if random.random() < 0.1:
        spo2 = random.randint(88, 92)  # Low oxygen
        
    vitals = {
        "patient_id": patient_id,
        "timestamp": datetime.now().isoformat(),
        "heart_rate_bpm": heart_rate,
        "blood_pressure": f"{systolic}/{diastolic}",
        "spo2_percent": spo2,
        "temperature_c": temp,
        "status": "normal" if heart_rate <= 100 and spo2 >= 95 else "alert"
    }
    return vitals

def generate_history(patient_id, hours=24):
    """
    Generates a history of vitals over the last X hours.
    """
    history = []
    current_time = datetime.now() - timedelta(hours=hours)
    
    while current_time < datetime.now():
        # Base vitals with some drift
        heart_rate = 70 + random.randint(-5, 5)
        
        history.append({
            "timestamp": current_time.isoformat(),
            "heart_rate": heart_rate
        })
        current_time += timedelta(minutes=30)
        
    return history

if __name__ == "__main__":
    print("--- Healix Medical Data Generator ---")
    
    # Example 1: Single reading
    vitals = generate_patient_vitals("P-1001")
    print(f"Current Vitals: {json.dumps(vitals, indent=2)}")
    
    # Example 2: History for chart plotting
    history = generate_history("P-1001", hours=12)
    print(f"\nGenerated {len(history)} history points for the last 12 hours.")
    
    # Save to file
    filename = "mock_vitals_data.json"
    with open(filename, "w") as f:
        json.dump({"vitals": vitals, "history": history}, f, indent=2)
    
    print(f"\nData successfully saved to {filename}")
