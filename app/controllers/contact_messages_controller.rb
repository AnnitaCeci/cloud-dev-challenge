class ContactMessagesController

def self.list
    items = ContactMessages.scan()
    items
    .map { |r| { :email => r.email, :name => r.name, :content => r.content } }
    .sort { |a, b| a[:created_at] <=> b[:created_at] }
    .to_json
end

def self.create(params)
    puts "aqui casual en create"
    item = ContactMessages.new(ID: SecureRandom.uuid, created_at: Time.now, updated_at: Time.now )
    item.email = params[:email]
    item.name = params[:name]
    item.content = params[:content]
    if item.save!
        lead = LandpageLeads.new(id: SecureRandom.uuid, created_at: Time.now, updated_at: Time.now )
        lead.first_name = params[:name]
        lead.email = params[:email]
        lead.save
    end
    item
end

def self.get(id)
    message = ContactMessages.query(key_condition_expression: "#H = :h",
    expression_attribute_names: {
      "#H" => "ID"
    },
    expression_attribute_values: {
      ":h" => id
    }).map { |r| { :content => r.content } }.to_json
end

def self.get_all(email)  
    message = ContactMessages.scan(filter_expression: "#H = :h",
    expression_attribute_names: {
      "#H" => "email"
    },
    expression_attribute_values: {
      ":h" => email
    }).map { |r| {:email => r.email, :content => r.content } }.to_json
end

end