/**
 * 
 *  Parsing zuora json response!
 */

public void explore(JSONParse node, Integer depth) {

    if(!(node.isObject() || node.isArray())) {
        System.debug( '*'.repeat(depth) + node.getValue());
    }
	
    if(node.isObject()) {
        for(String key : node.asMap().keySet()) {

            explore(node.get(key), depth + 1);
        }
    }
	
    if(node.isArray()) {
        for(JSONParse item : node.asList()) {
            explore(item, depth + 1);
        }
    }
}


// Load JSON Payment
StaticResource jsonResponse = [
  SELECT Id, Body
  FROM StaticResource
  WHERE Name = :'zuora'
  LIMIT 1
];

// Explore JSON
JSONParse testMe = new JSONParse(jsonResponse.Body.toString());
explore(testMe, 0);


String myJSONString = jsonResponse.Body.toString().replace('Success', 'success');
JSONParse root = new JSONParse(myJSONString);

System.debug('>>> root' + JSON.serializePretty(root));
System.debug('>>> isObject '+ root.isObject());
System.debug('>>> isArray '+ root.isArray());


  
Map<String, Boolean> someMap = new Map<String, Boolean>();
for (JSONParse j : root.asList()){
    System.debug('>>> each node ' +  j);
    System.debug('>>> each node ' +  j.get('Id'));
    System.debug('>>> each node ' +  j.get('success'));
    someMap.put(String.valueOf(j.get('Id').getValue()), Boolean.valueOf(j.get('success').getValue()));
    
}

System.debug('Wow here is my map '+ someMap);