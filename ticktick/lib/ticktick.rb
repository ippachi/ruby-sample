# typed: strict
class List
  extend T::Sig

  sig { params(name: String).void }
  def initialize(name:)
    @name = name
  end
end

module TaskManageable
  extend T::Sig
  extend T::Helpers
  abstract!

  sig { abstract.returns(Tasks) }
  def tasks; end

  sig(:final) { params(title: String, deadline: T.nilable(Time)).void }
  def add_task(title:, deadline: nil)
    tasks << Task.new(title: title, deadline: deadline)
  end

  sig(:final) { params(title: String).void }
  def done(title)
    task = tasks.find_by_title(title)
    tasks.delete(task) if task
  end
end

class TaskList < List
  include TaskManageable

  sig(:final) { returns(Tasks) }
  attr_reader :tasks

  sig(:final) { params(name: String).void }
  def initialize(name:)
    super
    @tasks = T.let(Tasks.new, Tasks)
  end

  sig(:final) { override.returns(Tasks) }
  def tasks
    @tasks
  end
end

class NoteList < List
  sig(:final) { returns(Notes) }
  attr_reader :notes

  sig(:final) { params(name: String).void }
  def initialize(name:)
    super
    @notes = T.let(Notes.new, Notes)
  end

  sig(:final) { params(title: String, deadline: T.nilable(Time)).void }
  def add_note(title:, deadline: nil)
    @notes << Note.new(title: title, deadline: deadline)
  end
end

class ListItem
  extend T::Sig

  sig(:final) { returns(String) }
  attr_reader :title

  sig { params(title: String, deadline: T.nilable(Time)).void }
  def initialize(title:, deadline: nil)
    @title = title
    @deadline = deadline
  end
end

class Task < ListItem
  include TaskManageable

  sig(:final) { override.params(title: String, deadline: T.nilable(Time)).void }
  def initialize(title:, deadline: nil)
    super()
    @tasks = T.let(Tasks.new, Tasks)
  end

  sig(:final) { override.returns(Tasks) }
  def tasks
    @tasks
  end
end

class Tasks
  extend T::Sig

  sig(:final) { params(tasks: T::Array[Task]).void }
  def initialize(tasks = [])
    @tasks = tasks
  end

  sig(:final) { params(task: Task).void }
  def <<(task)
    @tasks << task
  end

  sig(:final) { params(task: Task).void }
  def delete(task)
    @tasks.delete(task)
  end

  sig(:final) { params(title: String).returns(T.nilable(Task)) }
  def find_by_title(title)
    @tasks.find { |t| t.title == title }
  end
end

class Note < ListItem
end

class Notes
  extend T::Sig
  sig(:final) { params(notes: T::Array[Note]).void }
  def initialize(notes = [])
    @notes = notes
  end

  sig(:final) { params(note: Note).void }
  def <<(note)
    @notes << note
  end

  sig(:final) { params(title: String).void }
  def delete_by_title(title)
    note = @notes.find { |n| n.title == title }
    @notes.delete(note) if note
  end
end

task_list = TaskList.new(name: '資産運用システム')
task_list.add_task(title: 'CI/CDの整備')
T.must(task_list.tasks.find_by_title('CI/CDの整備')).add_task(title: 'CircleCIの設定', deadline: Time.now + 60 * 60 * 24 * 7)
T.must(task_list.tasks.find_by_title('CI/CDの整備')).done('CircleCIの設定')

note_list = NoteList.new(name: '買い物リスト')
note_list.add_note(title: '牛乳')
note_list.notes.delete_by_title('牛乳')
