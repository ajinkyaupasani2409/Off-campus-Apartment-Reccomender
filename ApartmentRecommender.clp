;Template for Questions
(deftemplate question 
    	(slot text)
    	(slot answerType)
    	(slot topic))

;Template for Answers
(deftemplate answer
    	(slot text)
    	(slot topic))

;Template for Suggestions
(deftemplate suggestions
    	(slot apartment)
    	(slot description)
    	(slot URL))


;Global Variables

(defglobal ?*gVarDistanceFromCollege* = (new nrc.fuzzy.FuzzyVariable "distanceFromCollege" 0.0 8.0 "miles"))

(defglobal ?*gVarBudget* = (new nrc.fuzzy.FuzzyVariable "budget $" 0.0 2000.0 "/month"))

(defglobal ?*gVarRoomates* = (new nrc.fuzzy.FuzzyVariable "roommates" 0 5 "persons"))

(defglobal ?*gVarSizeOfApt* = (new nrc.fuzzy.FuzzyVariable "sizeOfApt" 0.0 2500.0 "sq.ft."))

(defglobal ?*gVarCar* = (new nrc.fuzzy.FuzzyVariable "car" 0.0 5.0 "rating"))

(call nrc.fuzzy.FuzzyValue setMatchThreshold 0.2)


;List of Questions to be asked

(deffacts Questionnaire
    "Chosen by the user"
    (question (topic distanceFromCollege) (answerType number)
        (text "Q.How far can your apartment be from the college? 
            1. Very Close by
            2. A bit further
            3. Far away is fine
            Choose a number : "))
    
    (question (topic budget) (answerType number)
        (text "Q.How much can you afford to spend in rent? (Keep in mind that you would usually need about $250 for amenities)
            1. Very high
            2. High	
            3. Normal
            4. Low
            5. Penurious
            Choose a number : "))
    
    (question (topic roommates) (answerType number)
        (text "Q.How many roommates would you like to live with? 
            1. I'm not really a roommate person. I cherish personal space at my place of residence. 
            2. I don't mind a couple.
            3. Don't care about that. Plus, I know it will save me some rent money.
            Choose a number : "))
    
    (question (topic sizeOfApt) (answerType number)
        (text "Q.How big should your apartment be? 
            1. Big and spacious
            2. Medium
            3. Small size would do
            Choose a number : "))
    
    (question (topic car) (answerType number)
        (text "Q.Do you have a car to go use for daily commute? 
            1. Yes, I plan to use it everyday
            2. No, CTA or Uber&Lyft it is / Yes, but I don't intend to use it everyday 
            Choose a number : "))
    
)


;Functions to map answers
(deffunction mapdistanceFromCollege (?ans)
    "Mapping apartment distances to actual parameters"
    (if (eq ?ans 1) then (assert (valDistanceFromCollege (new nrc.fuzzy.FuzzyValue ?*gVarDistanceFromCollege* "closeBy"))))
    (if (eq ?ans 2) then (assert (valDistanceFromCollege (new nrc.fuzzy.FuzzyValue ?*gVarDistanceFromCollege* "far"))))
    (if (eq ?ans 3) then (assert (valDistanceFromCollege (new nrc.fuzzy.FuzzyValue ?*gVarDistanceFromCollege* "veryFar"))))
)

(deffunction mapbudget (?ans)
    "Estimating budget to actual price ranges"
    (if (eq ?ans 1) then (assert (valBudget (new nrc.fuzzy.FuzzyValue ?*gVarBudget* "veryCostly"))))
    (if (eq ?ans 2) then (assert (valBudget (new nrc.fuzzy.FuzzyValue ?*gVarBudget* "Costly"))))
    (if (eq ?ans 3) then (assert (valBudget (new nrc.fuzzy.FuzzyValue ?*gVarBudget* "Normal"))))
    (if (eq ?ans 4) then (assert (valBudget (new nrc.fuzzy.FuzzyValue ?*gVarBudget* "Cheap"))))
    (if (eq ?ans 5) then (assert (valBudget (new nrc.fuzzy.FuzzyValue ?*gVarBudget* "veryCheap"))))
)

(deffunction mapCar (?ans)
    "Mapping Discovery Time to a Value"
    (if (eq ?ans 1) then (assert (valCar (new nrc.fuzzy.FuzzyValue ?*gVarCar* "yes"))))
    (if (eq ?ans 2) then (assert (valCar (new nrc.fuzzy.FuzzyValue ?*gVarCar* "no"))))
)

(deffunction maproommates (?ans)
    "Assessing roommate parameters"
    (if (eq ?ans 1) then (assert (valRoommates (new nrc.fuzzy.FuzzyValue ?*gVarRoomates* "Less"))))
    (if (eq ?ans 2) then (assert (valRoommates (new nrc.fuzzy.FuzzyValue ?*gVarRoomates* "Normal"))))
    (if (eq ?ans 3) then (assert (valRoommates (new nrc.fuzzy.FuzzyValue ?*gVarRoomates* "Many"))))
)

(deffunction mapsizeOfApt (?ans)
    "Mapping apartment size requirements into variables"
    (if (eq ?ans 1) then (assert (valSizeOfApt (new nrc.fuzzy.FuzzyValue ?*gVarSizeOfApt* "big"))))
    (if (eq ?ans 2) then (assert (valSizeOfApt (new nrc.fuzzy.FuzzyValue ?*gVarSizeOfApt* "medium"))))
    (if (eq ?ans 3) then (assert (valSizeOfApt (new nrc.fuzzy.FuzzyValue ?*gVarSizeOfApt* "small"))))
)


;Initializing module

(defmodule init)
(defrule initialize
    (declare (salience 100))
    =>
    (load-package nrc.fuzzy.jess.FuzzyFunctions)
    
    ;Distance From College
    (bind ?xCloseBy (create$ 0.2 4.0))
    (bind ?yCloseBy (create$ 1.0 0.0))
    (?*gVarDistanceFromCollege* addTerm "closeBy" ?xCloseBy ?yCloseBy 2)
    (bind ?xfar (create$ 4.1 8.0 ))
    (bind ?yfar (create$ 0.0 1.0))
    (?*gVarDistanceFromCollege* addTerm "far" ?xfar ?yfar 2)
    (?*gVarDistanceFromCollege* addTerm "veryFar" "very far")


	;Budget
    (bind ?xcostly (create$ 1000.0 2000.0))
    (bind ?ycostly (create$ 0.0 1.0))
    (?*gVarBudget* addTerm "Costly" ?xcostly ?ycostly 2)
    (bind ?xcheap (create$ 150.0 1000.0))
    (bind ?ycheap (create$ 1.0 0.0))
    (?*gVarBudget* addTerm "Cheap" ?xcheap ?ycheap 2)
    (?*gVarBudget* addTerm "veryCostly" "very Costly")
    (?*gVarBudget* addTerm "veryCheap" "very Cheap")
    (?*gVarBudget* addTerm "Normal" "not costly and (not cheap)")    
    

     ;Car Commute
    (bind ?xAlways (create$ 0.0 2.5))
    (bind ?yAlways (create$ 1.0 0.0))
    (?*gVarCar* addTerm "yes" ?xAlways ?yAlways 2)
    (bind ?xNever (create$ 2.5 5.0))
    (bind ?yNever (create$ 0.0 1.0))
    (?*gVarCar* addTerm "no" ?xNever ?yNever 2)
        
    ;Number of Roommates
    (bind ?xLess (create$ 1 2))
    (bind ?yLess (create$ 1.0 0.0))
    (?*gVarRoomates* addTerm "Less" ?xLess ?yLess 2)
    (bind ?xMany (create$ 3 5))
    (bind ?yMany (create$ 0.0 1.0))
    (?*gVarRoomates* addTerm "Many" ?xMany ?yMany 2)
    (?*gVarRoomates* addTerm "Normal" "Not many and (not less)")
    
    ;Size of apartment
    (bind ?xBig (create$ 1000.0 2000.0))
    (bind ?yBig (create$ 0.0 1.0))
    (?*gVarSizeOfApt* addTerm "big" ?xBig ?yBig 2)
    (bind ?xSmall (create$ 10.0 999.0))
    (bind ?ySmall (create$ 1.0 0.0))
    (?*gVarSizeOfApt* addTerm "small" ?xSmall ?ySmall 2)
    (?*gVarSizeOfApt* addTerm "medium" "not big and (not small)") 
    
    
)

;Ask Questions Module--------------
(defmodule ask)
(deffunction askUser (?question ?answerType ?topic)
"Fetch answers from posed questions"
(bind ?answer "")
(while (not (numberp ?answer)) do 
(printout t ?question " ")
(bind ?answer (read)))
    (if(eq ?topic distanceFromCollege) then (mapdistanceFromCollege ?answer))
    (if(eq ?topic budget) then (mapbudget ?answer))
    (if(eq ?topic roommates) then (maproommates ?answer))
    (if(eq ?topic sizeOfApt) then (mapsizeOfApt ?answer))
    (if(eq ?topic car) then (mapCar ?answer))
(return ?answer))


;Mapping Topics on Questions
(defrule ask::askQuestionByTopic
"Ask questions based on topic and store answers"
	(declare (auto-focus TRUE))
	(MAIN::question (topic ?topic) (text ?text) (answerType ?answerType))
	(not (MAIN::answer (topic ?topic)))
	?ask <- (MAIN::ask ?topic)
=>
	(bind ?answer (askUser ?text ?answerType ?topic))
	(assert (answer (topic ?topic) (text ?answer)))
)

;Welcome Module which displays the initial message------------------
(defmodule welcome)
(defrule welcomeMessage
    =>
    (printout t "------------Welcome! Your search for apartment ends here------------" crlf crlf)
    (printout t "This system is calibrated to give you best results based on your suggestions." crlf crlf )
    (printout t "Enter your name: ")
    (bind ?name (read))
    (printout t "Hello "?name crlf)
    (printout t "Answer the questions according to your requirements" crlf crlf)
)


(defmodule queryMatch)
(defrule collegeAptDistance
    =>
    (assert (ask distanceFromCollege))
)

(defrule budgetOfRent
    =>
    (assert (ask budget))
)

(defrule numOfRoommates
    =>
    (assert (ask roommates))
)

(defrule aptSize
    =>
    (assert (ask sizeOfApt))
)

(defrule carCommuteProbability
    =>
    (assert (ask car))
)

;Apartment Suggestions
(defmodule database)

(defrule Apt1
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Costly"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "1116 W Polk St Unit 2")
            (description " 
                Neighbourhood : University Village
                Size : 1,200 Sq Ft
                Distance from East Campus : 0.5 mile
                Bedrooms : 3
                Rent : $2000
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.apartments.com/1116-w-polk-st-chicago-il-unit-2/21lgyyc/")))
)

(defrule Apt2
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Normal"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less small"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "Automatic Lofts, 410 S Morgan Street")
            (description " 
                Neighbourhood : University Village / Little Italy
                Distance from East Campus : 0.4 mile
                Size : 554 Sq Ft
                Bedrooms : 2
                Rent : $1,280
                Parking : Yes
                Public Transport: CTA Blue line in proximity")
            (URL "https://www.zillow.com/homes/for_rent/Chicago-IL/condo,apartment_duplex_type/41.875149,-87.652138_ll/17426_rid/3-_beds/0-442927_price/0-1750_mp/41.878916,-87.649022,41.868354,-87.668248_rect/15_zm/")))
)

(defrule Apt3
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Cheap"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less small"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "2628 S Kedzie Avenue #1")
            (description " 
                Neighbourhood : Little Village
                Distance from East Campus : 5.4 mile
                Size : - Sq Ft
                Bedrooms : 3
                Rent : $850
                Parking : Yes
                Public Transport: CTA Blue line in proximity")
            (URL "https://hotpads.com/2628-s-kedzie-ave-chicago-il-60623-sk8tvp/1/pad?price=0-950&beds=3-8plus")))
)

(defrule Apt4
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "veryCostly"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "500 S Clinton Street #542")
            (description " 
                Neighbourhood : South Loop
                Distance from East Campus : 0.6 mile
                Size : 1,041 Sq Ft
                Bedrooms : 2
                Rent : $1,995
                Parking : Yes
                Public Transport: CTA Blue line in proximity")
            (URL "https://hotpads.com/500-s-clinton-st-chicago-il-60607-skasgn/542/pad?price=0-2200&beds=2")))
)

(defrule Apt5
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "veryCostly"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "(1400-1405) S Halsted Street")
            (description " 
                Neighbourhood : University Village
                Distance from East Campus : 1.2 miles
                Size : -- Sq Ft
                Bedrooms : 2
                Rent : $2,200
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://hotpads.com/1425-s-halsted-st-chicago-il-60607-tjmnfy/2b/pad?price=0-2200&beds=2")))
)


(defrule Apt6
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Costly"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Less"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less small"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "1245 W Jackson Blvd #304")
            (description " 
                Neighbourhood : Near West Side
                Distance from East Campus : 1.3 mile
                Size : -- Sq Ft
                Bedrooms : 1
                Rent : $1,330
                Parking : Yes
                Public Transport: CTA Blue line in proximity")
            (URL "https://www.trulia.com/p/il/chicago/1245-w-jackson-blvd-304-chicago-il-60607--2194504605")))
)

(defrule Apt7
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Costly"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Less"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less small"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "2029 S Ruble St #1")
            (description " 
                Neighbourhood : Pilsen
                Distance from East Campus : 2.5 mile
                Size : -- Sq Ft
                Bedrooms : 1
                Rent : $1,000
                Parking : Yes
                Public Transport: CTA Bus and Red line in proximity")
            (URL "https://www.trulia.com/p/il/chicago/2029-s-ruble-st-1-chicago-il-60616--2344262073")))
)

(defrule Apt8
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Normal"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "906 S Loomis St ")
            (description " 
                Neighbourhood : University Village
                Distance from East Campus : 1.5 miles
                Size : -- Sq Ft
                Bedrooms : 2
                Rent : $1,400
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.trulia.com/p/il/chicago/906-s-loomis-st-garden-chicago-il-60607--2103818611")))
)

(defrule Apt9
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Normal"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "1819 S Ashland Ave #1")
            (description " 
                Neighbourhood : Pilsen
                Distance from East Campus : 2.3 miles
                Size : -- Sq Ft
                Bedrooms : 2
                Rent : $1,300
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.trulia.com/p/il/chicago/1819-s-ashland-ave-1-chicago-il-60608--2337621772")))
)

(defrule Apt10
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Normal"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "1722 W Hastings Street")
            (description " 
                Neighbourhood : Pilsen
                Distance from East Campus : 1.8 miles
                Size : -- Sq Ft
                Bedrooms : 3
                Rent : $1,800
                Parking : --
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://hotpads.com/1722-w-hastings-st-chicago-il-60608-sjzpcd/building?price=650-2900&beds=3-8plus")))
)

(defrule Apt11
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Normal"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "1825 W 17th Street")
            (description " 
                Neighbourhood : Heart of Chicago
                Distance from East Campus : 2.3 miles
                Size : 1,200 Sq Ft
                Bedrooms : 3
                Rent : $1,800
                Parking : --
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://hotpads.com/1722-w-hastings-st-chicago-il-60608-sjzpcd/building?price=650-2900&beds=3-8plus")))
)

(defrule Apt12
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less veryFar"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less veryCheap"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "1553 N Harding Ave")
            (description " 
                Neighbourhood : West Town
                Distance from East Campus : 6.8 miles
                Size : -- Sq Ft
                Bedrooms : 2
                Rent : $1,050
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.trulia.com/p/il/chicago/1553-n-harding-ave-3-chicago-il-60651--2196832554")))
)

(defrule Apt13
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less veryFar"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less veryCheap"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "no"))
    =>
    (assert (MAIN::suggestions
            (apartment "1635 N. Honore St.")
            (description " 
                Neighbourhood : Wicker Park
                Distance from East Campus : 4.7 miles
                Size : -- Sq Ft
                Bedrooms : 2
                Rent : $1,400
                Parking : --
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.trulia.com/c/il/chicago/1635-n-honore-st-1635-n-honore-st-chicago-il-60622--1001072024")))
)

(defrule Apt14
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Cheap"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "1357 N Homan Ave.")
            (description " 
                Neighbourhood : Humboldt Park
                Distance from East Campus : 6.2 miles
                Size : 875 Sq Ft
                Bedrooms : 2
                Rent : $1,240
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.trulia.com/c/il/chicago/1357-n-homan-1357-n-homan-ave-chicago-il-60651--2104582225")))
)

(defrule Apt15
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "more_or_less far"))
    (valBudget ?b&: (fuzzy-match ?b "more_or_less Cheap"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Many"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "1357 N Homan Ave.")
            (description " 
                Neighbourhood : Humboldt Park
                Distance from East Campus : 6.2 miles
                Size : 950 Sq Ft
                Bedrooms : 2
                Rent : $1,370
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://www.trulia.com/c/il/chicago/1357-n-homan-1357-n-homan-ave-chicago-il-60651--2104582225")))
)

(defrule Apt16
    (valDistanceFromCollege ?dC&: (fuzzy-match ?dC "closeBy"))
    (valBudget ?b&: (fuzzy-match ?b "veryCostly"))
    (valRoommates ?r&: (fuzzy-match ?r "more_or_less Normal"))
    (valSizeOfApt ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valCar ?c&: (fuzzy-match ?c "yes"))
    =>
    (assert (MAIN::suggestions
            (apartment "1343 W Flournoy #2")
            (description " 
                Neighbourhood : University Village
                Distance from East Campus : 1.3 miles
                Size : 1200 Sq Ft
                Bedrooms : 2
                Rent : $2,400
                Parking : Yes
                Public Transport: CTA Bus and Blue line in proximity")
            (URL "https://hotpads.com/1343-w-flournoy-st-chicago-il-60607-1mrzjvb/2/pad?price=2200-2900&beds=2")))
)


(defmodule output)
(defquery getResults
    (MAIN::suggestions 
        (apartment ?apartment)
        (description ?description)
        (URL ?URL))
)

;Displays all the results---------------
(defrule getAllResults
    =>
    (bind ?result (run-query* getResults))
    (bind ?checker 0)
    (printout t crlf "---------Our system generated some apartments that you might like--------"crlf)
    (while (?result next) do
        (printout t crlf)
      	(printout t "Apartment Address : " (?result getString apartment) crlf)
      	(printout t "Apartment Description : " (?result getString description) crlf)
      	(printout t "URL link : " (?result getString URL) crlf)
      	(++ ?checker))
    (if (eq ?checker 0) then
        (printout t "Sorry, we couln't find anything that matched your requirements. Try some other values." crlf))
)

;Running the code 
(reset)
(focus init welcome queryMatch database output)
(run)