class Department
  include ActiveModel::Model
  attr_accessor :name, :parent
  
  def initialize()
    @hash = {}
  end

  def add_department(dep_hash)

  end

  def add_subDepartment
    
  end

  def dept_exist?

  end
end
