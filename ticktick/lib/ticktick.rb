class List
  def initialize(name:)
    @name = name
  end
end

module TaskManageable
  attr_reader :tasks

  def initialize(*args, **kargs)
    super(*args, **kargs)
    @tasks = Tasks.new
  end

  def add_task(title:, deadline: nil)
    @tasks << Task.new(title: title, deadline: deadline)
  end

  def done(title)
    @tasks.delete(@tasks.find_by_title(title))
  end
end

class TaskList < List
  include TaskManageable
end

class NoteList < List
  attr_reader :notes

  def initialize(name:)
    super
    @notes = Notes.new
  end

  def add_note(title:, deadline: nil)
    @notes << Note.new(title: title, deadline: deadline)
  end
end

class ListItem
  attr_reader :title

  def initialize(title:, deadline: nil)
    @title = title
    @deadline = deadline
  end
end

class Task < ListItem
  include TaskManageable
end

class Tasks
  def initialize(tasks = [])
    @tasks = tasks
  end

  def <<(task)
    @tasks << task
  end

  def delete(task)
    @tasks.delete(task)
  end

  def find_by_title(title)
    @tasks.find { |t| t.title == title }
  end
end

class Note < ListItem
end

class Notes
  def initialize(notes = [])
    @notes = notes
  end

  def <<(note)
    @notes << note
  end

  def delete_by_title(title)
    @notes.delete(@notes.find { |n| n.title == title })
  end
end

task_list = TaskList.new(name: '資産運用システム')
task_list.add_task(title: 'CI/CDの整備')
task_list.tasks.find_by_title('CI/CDの整備').add_task(title: 'CircleCIの設定', deadline: Time.now + 60 * 60 * 24 * 7)
task_list.tasks.find_by_title('CI/CDの整備').done('CircleCIの設定')

note_list = NoteList.new(name: '買い物リスト')
note_list.add_note(title: '牛乳')
note_list.notes.delete_by_title('牛乳')