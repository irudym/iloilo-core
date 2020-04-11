# Ilo-Ilo data schema description

### Models

#### Quiz
* *title* {string} - title of the quiz
* *description* {text} - text, which describes the quiz
* [has_many] *questions*  - reference to question cards
* [belongs_to] *user*  - reference to admin user
* *duration* (default: 10 minutes)- **in minutes** when quiz may be available for students


#### Question
* *text* {text} - text of the question
* [has_many] *answers* - reference to an answers
* [has_many class: Answer] *correct_answers*  - reference to answers
* [belongs_to] *quiz* - reference to Quiz model

#### Answer
Question provided answers
* [belongs_to] *question* - reference to a question
* *text* {text} - the content of the answer
* *image_id* {TBD} - reference to image (optional)
* *correct* {boolean} - indicate if answer is the right answer to related question
* [belongs_to] *type* - question type: provided, open - means that an user need to write an answer


#### CorrectAnswer [DEPRECATED: use correct field in Answer instead]
to make a link between correct answers and questions
* [belongs_to] *question* - reference to a question
* [belongs_to] *answer* - reference to an answer


### Quiz result models
To manage users quiz responses.

#### Result
Overall quiz result for the particular user
* [belongs_to] *quiz*
* [belongs_to] *user* - reference to an user
* [has_many] *responses* - reference to quiz responses
* *score* {number} - result

#### Response
Response to the particular question for the particular user
* [belongs_to] *user*
* [belongs_to] *question*
* [belongs_to] *result*
* [belongs_to] *answer*
* *response* {text} - as it could be anything in case an open question (where an user should write an answer)

#### ActiveQuiz
* [belongs_to] *quiz* - a reference to a quiz
* *PIN* - uniq quiz identifier for students
* *started* (default: false) - indicates is the quiz started
* *ended_at*  - time till the quiz will be available
* [from referenced Quiz model] *duration* - quiz duration 
* [belongs_to] *user* - a reference to user (should be the same as Quiz's user)  

### Application users

Application supports two main types of users: **teachers** who create and manage quizzes, **students** who have access to quizzes only. In addition to that **students** my get access to history of their assessments. 


#### User
Common user of the application.
* *first_name*
* *last_name*
* *email* - could be used as a login to get the access to assessment history
* [belongs_to :optional] *group* - reference to student group

#### Admin
Admin user who can create quizzes, questions and manage students groups. 
* [belongs_to] *user* - a reference to an user record
* [has_many] *quizzes* - references to quizzes which were created by the teacher
* [has_many] *students* - the link set after the student pass the first quiz (PIN -> teacher) 


#### Student
* [belongs_to] *user*
* [belongs_to] *group*

#### Group
List of students' groups
* *name* - name of the group
* *description* - description of the group
* [has_many] *students* - references to students 


### Responses and connection log
In order to collect connection of user to a particular Quiz and users' answer there are two special models

### Connection
To log user (students) connection to a particular **activated** (and started) quiz
* [belongs_to] *user* - a reference to an user
* [belongs_to] *active_quiz* - reference to a particular activated quiz

### QuizResponse (word 'response' is reserved by Rails)
To collect user response to a Quiz
* [belongs_to] *user* - a reference to an user
* [belongs_to] *active_quiz* [TODO: may consider to user Quiz ID] - a reference to a quiz
* [belongs_to] *question* - a reference to a an question
* [has_and_belongs_to_many] *answers* - a reference to an answer through answer_quiz_response schema

Update of Response field **must not** be supported! 
