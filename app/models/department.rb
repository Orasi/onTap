class Department
  include ActiveModel::Model
  attr_accessor :name, :parent
  
  def initialize(department_hash)
    
    department_hash.each do |department_info|
      if !department_exist?(department_info["name"])
        add_department(department_info)
      end
      if department_info["parent"].nil?
        if department_exist?(department_info["parent"])
          addChild(department_info["parent"], department_info["name"])
        else
          add_department(department_info)
          addChild(department_info["parent"], department_info["name"])
        end
      end
    end
  end

  def add_department(dep_hash)
    if dep_hash["parent"].nil?
      Department.new(name: dep_hash["name"], parent: nil)
    else
      Department.new(name: dep_hash["name"], parent: dep_hash["parent"])    
    end
  end

  def department_exist?(dep_name)

  end

  def addChild(parent, child)
end
