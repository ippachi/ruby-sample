class List
  # @param name [String]
  def initialize(name:)
    @name = name
  end
end

module TaskManageable
  # @return [Tasks]
  attr_reader :tasks

  # @param title [String]
  # @param deadline [Time, nil]
  # @return [void]
  def add_task(title:, deadline: nil)
    tasks << Task.new(title: title, deadline: deadline)
  end

  # @param title [String]
  # @return [void]
  def done(title)
    task = tasks.find_by_title(title)
    tasks.delete(task) if task
  end
end

class TaskList < List
  include TaskManageable

  # @return [Tasks]
  attr_reader :tasks

  # @param name [String]
  # @return [void]
  def initialize(name:)
    super
    @tasks = Tasks.new
  end

  # @return [Tasks]
  def tasks
    @tasks
  end
end

class NoteList < List
  # @return [Notes]
  attr_reader :notes

  # @param name [String]
  # @return [void]
  def initialize(name:)
    super
    @notes = Notes.new
  end

  # @param title [String]
  # @param deadline [Time, nil]
  # @return [void]
  def add_note(title:, deadline: nil)
    @notes << Note.new(title: title, deadline: deadline)
  end
end

class ListItem
  # @return [String]
  attr_reader :title

  # @param title [String]
  # @param deadline [Time, nil]
  def initialize(title:, deadline: nil)
    @title = title
    @deadline = deadline
  end
end

class Task < ListItem
  include TaskManageable

  # @param title [String]
  # @param deadline [Time, nil]
  # @return void
  def initialize(title:, deadline: nil)
    super
    @tasks = Tasks.new
  end

  # @return [Tasks]
  def tasks
    @tasks
  end
end

class Tasks
  # @param tasks [Array<Task>]
  # @return void
  def initialize(tasks = [])
    @tasks = tasks
  end

  # @param task [Task]
  # @return [void]
  def <<(task)
    @tasks << task
  end

  # @param task [Task]
  # @return [void]
  def delete(task)
    @tasks.delete(task)
  end

  # @param title [String]
  # @return [Task]
  def find_by_title(title)
    @tasks.find { |t| t.title == title }
  end
end

class Note < ListItem
end

class Notes
  # @param notes [Array<Note>]
  # @return void
  def initialize(notes = [])
    @notes = notes
  end

  # @param note [Note]
  # @return [void]
  def <<(note)
    @notes << note
  end

  # @param title [String]
  # @return [void]
  def delete_by_title(title)
    note = @notes.find { |n| n.title == title }
    @notes.delete(note) if note
  end
end

task_list = TaskList.new(name: '資産運用システム')
task_list.add_task(title: 'CI/CDの整備')
task_list.tasks.find_by_title('CI/CDの整備').add_task(title: 'CircleCIの設定', deadline: Time.now + 60 * 60 * 24 * 7)
task_list.tasks.find_by_title('CI/CDの整備').done('CircleCIの設定')

note_list = NoteList.new(name: '買い物リスト')
note_list.add_note(title: '牛乳')
note_list.notes.delete_by_title('牛乳')
