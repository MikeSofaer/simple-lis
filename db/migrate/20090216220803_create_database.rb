class CreateDatabase < ActiveRecord::Migration
  def self.up
    create_table :people, :force => true do |t|
      t.string   "given_name",                      :null => false
      t.string   "family_name",                     :null => false
      t.string   "email",                           :null => false
      t.string   "sourced_id",                      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "people", ["email"], :name => "index_people_on_email", :unique => true
    add_index "people", ["sourced_id"], :name => "index_people_on_sourced_id"

    create_table "course_templates", :force => true do |t|
      t.string   "sourced_id",                      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "title",                      :null => false
      t.string "description"
      t.string "code",                      :null => false
    end
    add_index "course_templates", ["sourced_id"], :name => "index_course_templates_on_sourced_id", :unique => true
    
    create_table "terms", :force => true do |t|
      t.string "sourced_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "title", :null => false
      t.datetime "starts_at"             
      t.datetime "ends_at"
    end
    add_index "terms", ["sourced_id"], :name => "index_terms_on_sourced_id", :unique => true

    create_table "groups", :force => true do |t|
      t.string "sourced_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "title",                      :null => false
      t.string "category",                      :null => false
      t.string "sub_category",                      :null => false
      t.string "description"
      t.string "parent_sourced_id"
      t.string "location"
    end
    add_index "groups", ["sourced_id"], :name => "index_groups_on_sourced_id", :unique => true
    add_foreign_key :groups, :parent_sourced_id, :groups, :sourced_id

    create_table "course_offerings", :force => true do |t|
      t.string   "sourced_id",                      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "term_sourced_id", :null => false
      t.string "course_template_sourced_id", :null => false
      t.string "group_sourced_id"
      t.foreign_key :term_sourced_id, :terms, :sourced_id, :on_delete => :restrict
      t.foreign_key :course_template_sourced_id, :course_templates, :sourced_id
      t.foreign_key :group_sourced_id, :groups, :sourced_id, :on_delete => :set_null
    end
    add_index "course_offerings", ["sourced_id"], :name => "index_offerings_on_sourced_id", :unique => true

    create_table "course_sections", :force => true do |t|
      t.string   "sourced_id",                      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "course_offering_sourced_id", :null => false
      t.string "description"
      t.string "label",                      :null => false
      t.foreign_key :course_offering_sourced_id, :course_offerings, :sourced_id
    end
    add_index "course_sections", ["sourced_id"], :name => "index_course_sections_on_sourced_id", :unique => true

    create_table "memberships"  , :force => true do |t|
      t.string   "sourced_id",                      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "target_type",  :null => false
      t.string "target_sourced_id", :null => false
      t.string "person_sourced_id", :null => false
      t.string "term_sourced_id"
      t.string "role", :null => false
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.foreign_key :person_sourced_id, :people, :sourced_id, :on_delete => :cascade
      t.foreign_key :term_sourced_id, :terms, :sourced_id
    end
    add_index "memberships", ["sourced_id"], :name => "index_memberships_on_sourced_id", :unique => true
    add_index "memberships", ["person_sourced_id"], :name => "index_memberships_on_person_sourced_id"
    add_index "memberships", ["term_sourced_id"], :name => "index_memberships_on_term_sourced_id"
    add_index "memberships", ["target_type", "target_sourced_id"], :name => "index_memberships_on_target"

    create_table "meetings",  :force => true do |t|
      t.string "sourced_id",  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "target_type", :null => false
      t.string "target_sourced_id", :null => false
      t.text "raw_icalendar", :null => false
    end
    add_index "meetings", ["sourced_id"], :name => "index_meetings_on_sourced_id", :unique => true
    add_index "meetings", ["target_type", "target_sourced_id"], :name => "index_meetings_on_target"
  end

  def self.down
  end
end
