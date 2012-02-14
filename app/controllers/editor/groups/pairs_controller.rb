class Editor::Groups::PairsController < ApplicationController

  def new
    keys = %w(week day_of_the_week pair_number).map {|k| k.to_sym }
    allowed_params = keys.map {|i| params[i].nil?? {} : {i => params[i]}}.inject({}) {|r,i| r.merge i }
    @pair = Pair.new(allowed_params)
    @pair.active_at = Date.today
    @pair.guess_expire_date
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def create
    flash[:error] = nil
    @pair = Pair.new do |p|
      p.classroom_id = params[:classroom_id]
      p.day_of_the_week = params[:day_of_the_week]
      p.pair_number = params[:pair_number]
      p.week = params[:week]
      p.active_at = Date.today
      p.guess_expire_date
    end
    @container = params[:container]
    unless @pair.valid?
      flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe
      @pair = nil
    else
      @pair.save
    end

    respond_to do |format|
      format.js
    end
  end

  def edit
    @pair = Pair.find_by_id(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    flash[:error] = nil
    @group = Group.find(params[:group], :include => {:jets => {:subgroups => {:pair => :charge_card}}})
    @pair = Pair.find_by_id(params[:id].to_i, :include => [:subgroups])
    @prev_pair = @pair.clone
    @prev_pair.readonly!
    if params[:get_subgroups] && params[:pair]
      @pair.attributes = params[:pair]
      unless @pair.valid?
        flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe
        @pair.reload
      else
        @pair.save
        @pair.subgroups.destroy_all
        @pair.charge_card.jets.each do |jet|
          subgroup = @pair.subgroups.new(:jet_id => jet.id, :number => 0)
          unless subgroup.valid?
            flash[:error] = subgroup.errors[:base].to_a.join('<br />').html_safe
          else
            subgroup.save
          end
        end
        redirect_to :action => 'edit'
      end
    elsif params.include? :pair_number and params.include? :day_of_the_week
      # If it's a pair movement into another day/pair number
      # First, remember old subgroup and week_number
      subgroup = @pair.subgroups.select{|s| s.jet.group_id==@group.id}.first
      old_week = @pair.week
      old_sub = subgroup.number
      # Second, move the pair into target cell (account target subgroup and week number)
      @pair.day_of_the_week = params[:day_of_the_week].to_i if params[:day_of_the_week]
      @pair.pair_number = params[:pair_number].to_i if params[:pair_number]
      @pair.week = params[:week] ? params[:week].to_i : 0
      subgroup.number = params[:subgroup] ? params[:subgroup].to_i : 0
      # Third, if pair become invalid, try to reset to old week and subgroup
      @pair.week = old_week     if @pair.invalid?
      subgroup.number = old_sub if subgroup.invalid?
      # So, try to save it
      unless @pair.valid? and subgroup.valid?
        flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe
        @pair.reload
        subgroup.reload
      else
        subgroup.save
        @pair.save
      end
      respond_to do |format|
        @pairs = @group.subgroups.map{|s| [s.pair, s.number]}
        format.js
      end
    else
      # Simple edit
      @pair.attributes = params[:pair]
      unless @pair.valid?
        flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe
        @pair.reload
        @pair.charge_card_id = nil
        @pair.subgroups.destroy_all
        @pair.save
        redirect_to :action => 'edit'
      else
        @pair.save
        @pairs = @group.subgroups.map{|s| [s.pair, s.number]}
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def destroy
    flash[:error] = nil
    @id = params[:id].to_i
    pair = Pair.find_by_id(@id)
    @pair = pair.clone
    @pair.readonly!
    pair.destroy

    respond_to do |format|
      format.js
    end
  end

end
