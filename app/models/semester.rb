class Semester < ActiveRecord::Base
  has_many :charge_cards, :dependent => :destroy

  validates :number, :uniqueness   => { :scope => [:year, :full_time] },
                     :numericality => { :only_integer => true, 
                                        :equal_to => Proc.new do |s| 
                                                       [1,2].include?(s.number) ? s.number : "1 или 2"
                                                     end
                                      }
  validates :year, :numericality => { :only_integer => true,
                                      :greater_than => 2000,
                                      :less_than    => 2100 }

  default_scope order '"semesters"."year" DESC, "semesters"."number" DESC, "semesters"."full_time" DESC'

  def to_label
    "#{academic_year} #{number}-й #{full_time ? 'очный' : 'заочный' } семестр"
  end

  def to_s
    to_label
  end

  def academic_year
    "#{year}/#{year+1}"
  end

  def charge_card_count
    charge_cards.count
  end

end
