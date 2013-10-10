# -*- encoding : utf-8 -*-
class Editor::Groups::PairsController < ApplicationController
  before_filter :preload_data, :except => [:destroy]

  def new
  end

  def create
    keys = %w(week day_of_the_week pair_number).map {|k| k.to_sym }
    pair_params = Hash[keys.map {|i| [i, (params[i] || nil)] }]
    pair_params[:classroom_id] = nil
    @pair = Pair.includes(Pair::RELATIONS_TO_INCLUDE).where(pair_params).first_or_initialize
    @pair.active_at = current_semester.start
    @pair.expired_at = current_semester.end
    unless @pair.save
      conflict_params = [params[:day_of_the_week], params[:pair_number], nil]
      pairs = Pair.find_all_by_day_of_the_week_and_pair_number_and_classroom_id(*conflict_params)
      charge_card_ids = @group.charge_cards.map{ |c| c.id }
      pairs.find_all { |p| charge_card_ids.include? p.charge_card_id or p.charge_card_id.nil? }.each { |p| p.destroy }
      unless @pair.save
        flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe
      end
    end
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def edit
    @pair = Pair.includes(Pair::RELATIONS_TO_INCLUDE).find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    flash[:error] = nil
    logger.debug 'Loading pair...'
    @pair = Pair.includes(Pair::RELATIONS_TO_INCLUDE).find(params[:id])
    @prev_pair = @pair.dup
    @prev_pair.readonly!
    if params[:get_subgroups] && params[:pair]
      @pair.transaction do
        logger.debug 'Saving pair. Charge card or classroom is changed...'
        @pair.attributes = params[:pair]
        if @pair.charge_card_id_changed? and @pair.charge_card
          logger.debug 'Saving pair. Updating subgroups...'
          @pair.subgroups.destroy_all
          @pair.charge_card.jets.each do |jet|
            subgroup = @pair.subgroups.new(:jet_id => jet.id, :number => 0)
            subgroup.number = params[:subgroup] if jet.group_id == @group.id and params[:subgroup]
            unless subgroup.save
              flash[:error] = subgroup.errors[:base].to_a.join('<br />').html_safe
            end
          end
        end
        # If there is preferred classrooms for charge card, try to set it up.
        if @pair.charge_card_id_changed? and @pair.charge_card and @pair.classroom_id.nil?
          logger.debug 'Saving pair. Try to set up classroom...'
          @pair.charge_card.preferred_classrooms.each do |classroom|
            @pair.classroom = classroom
            break if @pair.valid?
          end
          @pair.classroom_id = nil if @pair.invalid?
        end
        logger.debug 'Saving pair. Validate and save...'
        success = @pair.save
        respond_to do |format|
          @pair.reload
          @pairs = @group.pairs_with_subgroups
          format.js do
            logger.debug 'Start rendering template...'
            flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe unless success
            render :edit
            raise ActiveRecord::Rollback unless success
          end
        end
      end
    elsif params.include? :pair_number and params.include? :day_of_the_week
      # If it's a pair movement into another day/pair number
      # First, remember old subgroup and week_number
      logger.debug 'Moving pair...'
      subgroup = @pair.subgroups.select{|s| s.jet.group_id==@group.id}.first
      old_week = @pair.week
      old_sub = subgroup.number
      # Second, move the pair into target cell (account target subgroup and week number)
      @pair.day_of_the_week = params[:day_of_the_week].to_i if params[:day_of_the_week]
      @pair.pair_number = params[:pair_number].to_i if params[:pair_number]
      @pair.week = params[:week] ? params[:week].to_i : 0
      subgroup.number = params[:subgroup] ? params[:subgroup].to_i : 0
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
        @pairs = @group.pairs_with_subgroups
        format.js
      end
    else
      # Simple edit
      logger.debug 'Saving pair and closing editor...'
      @pair.attributes = params[:pair]
      unless @pair.save
        flash[:error] = @pair.errors[:base].to_a.join('<br />').html_safe
        @pair.reload
        respond_to do |format|
          format.js { render :edit }
        end
      else
        @pairs = @group.pairs_with_subgroups
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def destroy
    flash[:error] = nil
    @id = params[:id].to_i
    pair = Pair.find(@id)
    @pair = pair.clone
    @pair.readonly!
    pair.destroy

    respond_to do |format|
      format.js
    end
  end

  protected

  def preload_data
    @group = Group.for_groups_editor.find(params[:group_id])
    @charge_cards = ChargeCard.joins(:jets).includes(:jets).where(
        :jets => {:group_id => @group.id}, :semester_id => current_semester.id
    ).select("charge_cards.id, charge_cards.editor_name").order(:editor_name)
    @classrooms = Classroom.all_with_recommended_first_for(@group.department)
  end

end
