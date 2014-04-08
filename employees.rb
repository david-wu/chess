class Employee
  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @employees = []
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  def initialize(name, title, salary, employees = [])
    super(name, title, salary)
    @employees = employees
  end

  def bonus(multiplier)
    # bonus = @employees.inject { |total, employee| total += employee.salary } * multiplier

    return @salary if @employees.empty?

    underling_bonus = 0
    @employees.each do |employee|
      underling_bonus += employee.bonus(1)
    end

    (@salary + underling_bonus) * multiplier
  end
end


steve = Employee.new("steve", "underling", 25_000)
marla = Employee.new("marla", "underling", 30_000)
bob = Manager.new("bob", "ling", 45_000, [steve, marla])
bill = Manager.new("bill", "overling", 120_000, [bob])

p bill.bonus(0.10)

