import json
from pprint import pprint

with open('RFM_Classes.json', 'r') as f:
    customers_dict = json.load(f)

pprint(customers_dict['About to sleep'])
pprint(customers_dict['At risk'])
pprint(customers_dict['Champions'])
pprint(customers_dict['Loyals'])
pprint(customers_dict['Need attention'])
pprint(customers_dict['New customers'])
pprint(customers_dict['Potential loyalist'])
