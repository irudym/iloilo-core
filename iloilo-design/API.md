# API description and specification

All API request should be based on JSON:API Specification [https://jsonapi.org/]. JSON:API is a specification for how a client should request that resources be fetched or modified, and how a server should respond to those requests.

### Resource object 

An resource object must contains at least following fields: **id** and **type**. All model attributes mush be specified in **attributes** object. 

## Create resource

The creating resource object must contains **type** field. 
If a relationship is provided in the relationships member of the resource object, its value **must** be a relationship object with a data member.

For instance, a new question request may look like: 
~~~
POST /questions

{
  "data": {
    "type": "question",
    "attributes": {
      "text": "How JSON stands for?" 
    },
    "relationships": {
      "quiz": {
        "data": {
          "type": "quiz",
          "id": 1
        }
      }
    }
  }
}
~~~ 

### Response

If the requested resource has been created successfully, the server must return a **201 Created** status code and JSON object which describes the created resource with generated ID.


## Errors

Error objects provide additional information about problems encountered while performing an operation. Error objects must be returned as an array keyed by **errors** in the top level of a JSON:API document.

The error response may look like below.

~~~
HTTP/1.1 422 Unprocessable Entity

{
  "errors": [
    {
      "status": "422",
      "title":  "Invalid Attribute",
      "detail": "First name must contain at least three characters."
    }
  ]
}
~~~

## Questions API

Only an admin user can get access to Questions API, common users get list of question through Quiz API and only with provided Quiz PIN code which should be valid only for the limited amount of time. This avoid students from downloading Quiz possible questions and preparing them-self before an assessment.  

### POST

#### POST questions without answer

The POST request should look like: '**POST /question**', the request body should be following JSON object:
~~~
{
  "data": {
    "type": "question",
    "attributes": {
      "text": "How big is an elephant?" 
    },
    "relationships": {
      "quiz": {
        "data": {
          "type": "quiz",
          "id": 1
        }
      }
    }
  }
}
~~~ 

#### POST questions with answers
In this case the post request body should look like: 
~~~
{
  "data": {
    "type": "question",
    "attributes": {
      "text": "How much is 2*2?" 
    },
    "relationships": {
      "quiz": {
        "data": {
          "type": "quiz",
          "id": 1
        }
      }
      "answers": {
        data: [
          {
            "type": "answer",
            "attributes": { "text": 4 }, 
          },
          {
            "type" "answer",
            "attributes": { "text": 5 },
          }
        ]
      } 
    }
  }
}
~~~ 

Where **answers** is an object with **data** array which describes provided answers. 

#### POST questions with answers and right answers

In order to indicated right answers is to pass additional answer's attribute **correct** which could be *true* or *false*. Quiz ID **must** be provided, otherwise the resource won't be created.

~~~
  "data": {
    "type": "question",
    "attributes": {
      "text": "How much is 2*2?" 
    },
    "relationships": {
      "quiz": {
        "data": {
          "type": "quiz",
          "id": 1
        }
      }
      "answers": {
        data: [
          {
            "type": "answer",
            "text": "4",
            correct: true
          },
          {
            "type": "answer",
            "text": "5",
            correct: false
          }
        ]
      }
    }
  }
~~~        


### UPDATE


## Activate a quiz

To start a quiz an **admin** should create a ActiveQuiz resource by sending post request: '**POST /activequizzes**'. THe server must return a following
object as a response:

In case the success, status should be 201
~~~
{
  "data": {
    "type": "activequiz",
    "id": 1,
    "attributes": {
      "ended_at": "time of the validity"
      "created_at": "time of creation"
      "duration":  10, //get from referenced quiz
      "started": true // true if the quiz started
    },
    "relationships": {
      "quiz": {
        "type": "quiz",
        "id": 1
      }   
    }
  }
}
~~~

in case the quiz is active it returns a error
~~~
HTTP/1.1 422 Unprocessable Entity

{
  "errors": [
    {
      "status": "422",
      "title":  "Quiz is active",
      "detail": "Quiz is already activated and still valid, please delete activation to start quiz again"
    }
  ]
}
~~~

## Start a quiz

To start a quiz an admin should update activated quiz by sending '**UPDATE /active_quizzes/:id**' request. 

## Client APIs

#### Connect to active quiz and get information about the quiz

To connect to an active quiz an user should send a request: '**GET/evaluations/:PIN**', where PIN is active
quiz identifier.
 