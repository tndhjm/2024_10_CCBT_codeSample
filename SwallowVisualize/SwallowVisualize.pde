Table reference;

//data
int dataNum; 

String[] taxonomyOrder = {"界", "門", "綱", "目", "亜目", "上科", "科", "属"};
int taxonomyNum = taxonomyOrder.length;

int taxonomyHierarchy[][];
String taxonomyLabels[][];
ArrayList<ArrayList<Integer>> taxonomyCounter = new ArrayList<ArrayList<Integer>>();

float h = 240;
float s = 83;
float b = 65;

//view
float anglePerOne;

void setup() {
    size(720, 720);
    pixelDensity(displayDensity());
    colorMode(HSB, 360, 100, 100);

    loadData();

    anglePerOne = 360/dataNum;

    noLoop();
}

void draw() {
    background(0, 0, 100);

    translate(width/2, height/2);
    rotate(radians(-90));

    fill(255);
    noStroke();

    for(int i = 0; i < taxonomyNum; i++) {
        int currentAngle = 0;
        float currentR = map(i, 0, taxonomyNum-1, 600, 100);
        float currentS = map(i, 0, taxonomyNum-1, s, 10);
        float currentB = map(i, 0, taxonomyNum-1, b, 95);

        for(int j = 0; j < taxonomyCounter.get(i).size(); j++) {
            float currentH = map(j, 0, taxonomyCounter.get(i).size()-1, h, 120);
            if(taxonomyCounter.get(i).get(j) == 0) {
                fill(0, 0, 100);
                arc(0, 0, currentR, currentR, radians(currentAngle), radians(currentAngle+anglePerOne), PIE);
                
                currentAngle += anglePerOne;
            }
            else {
                fill(currentH, currentS, currentB);
                float angle = taxonomyCounter.get(i).get(j)*anglePerOne;
                println(angle);
                arc(0, 0, currentR, currentR, radians(currentAngle), radians(currentAngle+angle), PIE);

                currentAngle += angle;
            }
        }
    }

    fill(0, 0, 100);
    ellipse(0, 0, 100, 100);
}

void loadData() {
    reference = loadTable("expanded-biological-data.csv");

    dataNum = reference.getRowCount();
    println(dataNum);
    
    taxonomyNum = taxonomyOrder.length;
    taxonomyHierarchy = new int[dataNum][taxonomyNum];
    taxonomyLabels = new String[dataNum][taxonomyNum];

    
    for(int i = 0; i < dataNum; i++) {
        String temp = reference.getString(i, 2);
        String[] spliter = split(temp, ":");
        println(spliter);

        int[] taxonomyIDs = new int[taxonomyNum];
        String[] taxonomyTitles = new String[taxonomyNum];

        //初期化
        for(int t = 0; t < taxonomyNum; t++) {
            taxonomyIDs[t] = 0;
            taxonomyTitles[t] = null;
        }

        if(i == 0) {
            for(int j = 0; j < spliter.length; j++) {
                for(int a = 0; a < taxonomyNum; a++) {
                    if( spliter[j].contains( taxonomyOrder[a] ) ) {
                        taxonomyIDs[a] = 1;
                        taxonomyTitles[a] = spliter[j];

                        break;
                    }
                }
            }   
        }
        else {
            for(int j = 0; j < spliter.length; j++) {
                for(int a = 0; a < taxonomyNum; a++) {
                    if( spliter[j].contains( taxonomyOrder[a] ) ) {
                        int id = taxonomyHierarchy[i-1][a];
                        if( spliter[j].equals( taxonomyLabels[i-1][a] ) == false ) {
                            id++;
                        }
                        taxonomyIDs[a] = id;
                        taxonomyTitles[a] = spliter[j];

                        break;
                    }
                }
            }   
        }

        taxonomyHierarchy[i] = taxonomyIDs;
        taxonomyLabels[i] = taxonomyTitles;

        println(taxonomyHierarchy[i]);
    }

    for(int i = 0; i < taxonomyNum; i++) {
        ArrayList<Integer> counterList = new ArrayList<Integer>();
        int currentID = 0;
        int idCounter = 1;
        for(int j = 0; j < dataNum; j++) {
            if(taxonomyHierarchy[j][i] == 0) {
                counterList.add(0);
            }
            else if(j == 0) {
                currentID = taxonomyHierarchy[j][i];
            }
            else {
                if(taxonomyHierarchy[j][i] == currentID) {
                    idCounter++;
                }
                else {
                    counterList.add(idCounter);
                    currentID = taxonomyHierarchy[j][i];
                    idCounter = 1;
                }

                if(j == dataNum-1) {
                    counterList.add(idCounter);
                }
            }

        }
        taxonomyCounter.add(counterList);
        println(taxonomyCounter.get(i));
    }
    
} 
