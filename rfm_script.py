import csv
import sys
import json
import pandas as pd
import numpy as np

#Gives a new rfm file
f = pd.read_csv(sys.argv[1])
keep_col = ['Sold_to_party','Total_Score','customerType']
new_f = f[keep_col]
new_f.to_csv("newRFM.csv",index=False)


#EDIT THIS LIST WITH YOUR REQUIRED JSON KEY NAMES
fieldnames=["sold_to","recency","frequency","Monetary","R_Score","F_Score","M_Score","Total","FM_Score","CustomerType"]
def convert(filename):
 csv_filename = filename[0]
 print "Opening CSV file: ",csv_filename 
 f=open(csv_filename, 'r')
 csv_reader = csv.DictReader(f,fieldnames)
 json_filename = csv_filename.split(".")[0]+".json"
 print "Saving JSON to file: ",json_filename
 jsonf = open(json_filename,'w')

 data ={"Champions" : [],
        "Loyals" : [],
        "At risk" : [],
        "About to sleep" : [],
        "Hibernating" : [],
        "Need attention" : [],
        "New customers" : [],
        "Potential loyalist" : []
        }
 for r in csv_reader:
     if r["CustomerType"]=="Champions":
         data["Champions"].append({r["sold_to"]:r["Total"]})         
     elif r["CustomerType"]=="Loyal":
        data["Loyals"].append({r["sold_to"]:r["Total"]})
     elif r["CustomerType"]=="About to sleep":
        data["About to sleep"].append({r["sold_to"]:r["Total"]})    
     elif r["CustomerType"]=="At risk":
        data["At risk"].append({r["sold_to"]:r["Total"]})
     elif r["CustomerType"]=="Need Attention":
        data["Need attention"].append({r["sold_to"]:r["Total"]})    
     elif r["CustomerType"]=="New":
        data["New customers"].append({r["sold_to"]:r["Total"]})   
     elif r["CustomerType"]=="Potential Loyalist":
        data["Potential loyalist"].append({r["sold_to"]:r["Total"]})    

 data = json.dumps(data)
 #data = json.dumps([r for r in csv_reader])
 jsonf.write(data)
 #jsonf.write({"Champions ":data})
 f.close()
 jsonf.close()
 
if __name__=="__main__":
 convert(sys.argv[1:])


