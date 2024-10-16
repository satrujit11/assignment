class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :projects
  has_many :tasks
  has_many :comments
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigned_user_id"
  has_many :search_queries, dependent: :destroy

  def admin?
    self.admin
  end
end
