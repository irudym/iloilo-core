# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_16_111557) do

  create_table "active_quizzes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "pin"
    t.boolean "started", default: false
    t.datetime "ended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quiz_id", null: false
    t.bigint "user_id"
    t.index ["quiz_id"], name: "index_active_quizzes_on_quiz_id"
    t.index ["user_id"], name: "index_active_quizzes_on_user_id"
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "question_id", null: false
    t.boolean "correct", default: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "answers_quiz_responses", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "answer_id"
    t.bigint "quiz_response_id"
    t.index ["answer_id"], name: "index_answers_quiz_responses_on_answer_id"
    t.index ["quiz_response_id"], name: "index_answers_quiz_responses_on_quiz_response_id"
  end

  create_table "connections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "active_quiz_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active_quiz_id"], name: "index_connections_on_active_quiz_id"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "correct_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "answer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["answer_id"], name: "index_correct_answers_on_answer_id"
    t.index ["question_id"], name: "index_correct_answers_on_question_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quiz_id", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_responses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "active_quiz_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "score"
    t.bigint "question_id", null: false
    t.index ["active_quiz_id"], name: "index_quiz_responses_on_active_quiz_id"
    t.index ["question_id"], name: "index_quiz_responses_on_question_id"
    t.index ["user_id"], name: "index_quiz_responses_on_user_id"
  end

  create_table "quizzes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "duration", default: 10
    t.bigint "user_id"
    t.integer "max_score", default: 100
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_quizzes", "quizzes"
  add_foreign_key "active_quizzes", "users"
  add_foreign_key "admins", "users"
  add_foreign_key "answers", "questions"
  add_foreign_key "connections", "active_quizzes"
  add_foreign_key "connections", "users"
  add_foreign_key "correct_answers", "answers"
  add_foreign_key "correct_answers", "questions"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_responses", "active_quizzes"
  add_foreign_key "quiz_responses", "questions"
  add_foreign_key "quiz_responses", "users"
  add_foreign_key "quizzes", "users"
end
