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
        "Loyal" : [],
        "At risk" : [],
        "About to sleep" : [],
        "Hibernating" : [],
        "Need Attention" : [],
        "New" : [],
        "Potential loyalist" : []
        }
 f = ["Champions","Loyal","Abput to sleep","At risk","Need Attention","New","Potential loyalist"]
 sold_id = []
 rfm = []
 for a in f
     for r in csv_reader:
         if r[a]==a:
             sold_id.append({r["sold_to"]})
             rfm.append({r["Total"]})
     data[a].append[{"Id" : t, "RFM Score": s} for t,s in zip(sold_id,rfm)]        
         

 data = json.dumps(data)
 #data = json.dumps([r for r in csv_reader])
 jsonf.write(data)
 #jsonf.write({"Champions ":data})
 f.close()
 jsonf.close()
 
if __name__=="__main__":
 convert(sys.argv[1:])


