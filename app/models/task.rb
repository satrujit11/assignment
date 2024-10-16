class Task < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :project
  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id", optional: true
end
