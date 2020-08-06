##################################
# Web App with a DynamodDB table
##################################

# Class for DynamoDB table
# This could also be another file you depend on locally.

class ContactMessages
    
    include ActiveModel::Validations
    include Aws::Record
    string_attr :ID, hash_key: true
    string_attr :email, range_key: true
    string_attr :name
    string_attr :content
    epoch_time_attr :created_at
    epoch_time_attr :updated_at

    global_secondary_index(
      :emailIndex,
      hash_key: :email,
      projection: {
        projection_type: "ALL"
      }
    )

    validates_presence_of :email, :name, :content, :message => "empty fields"
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  end