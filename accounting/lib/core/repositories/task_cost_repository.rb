class TaskCostRepository < Hanami::Repository
  associations do  
    belongs_to :task
  end

  def set_cost
    rand(10..49)
  end
end
