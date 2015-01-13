class Department
  include ActiveModel::Model
  attr_accessor :name, :parent
  
  def self.get_top_levels
    top_levels=Array.new
    department_list=query_api()
    department_list.each do |department_hash|
      if department_hash["parent"].nil?
        top_levels << department_hash["name"]
      end
    end
    return top_levels
  end

  def self.get_children(dep)
    
  end

  def self.query_api
    auth = {:username => "bluesource", :password => "ontap"}
    department_list = HTTParty.get("http://bluesourcestaging.herokuapp.com/api/department_list.json?", :basic_auth => auth)
    return department_list
  #  department_list.each do |department_hash|
  #    if department_hash["parent"].nil?
  #      Department.new(name: department_hash["name"])
  #    else
  #      Department.new(name: department_hash["name"], parent: department_hash["parent"])
  #    end
  #  end

  end
end
