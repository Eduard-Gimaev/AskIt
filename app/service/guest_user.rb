class GuestUser
  def guest?
    true
  end

  def author?(_)
  end

  def method_missing(name, *args, &block)
    if name.to_s.end_with?("_role?")
       false
    else
      super(name, *args, &block)
    end
  end

  def respond_to_missing?(name, include_private)
    if name.to_s.end_with?("_role?")
      false
    else
      super(name, include_private)
    end
  end

  def decorate
    self
  end

  def name
    "Guest"
  end

  def name_or_email
  end

  def email
    "guest@example.com"
  end
end
