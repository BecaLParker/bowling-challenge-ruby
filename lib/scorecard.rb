# frozen_string_literal: true

class Scorecard
  attr_reader :current_frame, :current_roll, :frame_scores, :frame_bonus_type, :strike_bonus_holder, :roll_scores

  def initialize
    @current_frame = 1
    @current_roll = 1
    @roll_scores = []
    @frame_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @frame_bonus_type = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  end

  def roll_1(pins)
    raise 'Max pins exceeded, recheck and try again' if pins > 10

    @roll_scores << [pins]
    normal_scoring(pins)
    spare_scoring(pins) if @frame_bonus_type[@current_frame - 2] == :spare
    strike_scoring(pins) if @frame_bonus_type[@current_frame - 2] == :strike
    if @frame_bonus_type[@current_frame - 3] == :strike && @roll_scores[@current_frame - 2][0] == 10
      chain_strike_scoring(pins)
    end

    if pins == 10
      @frame_bonus_type[@current_frame - 1] = :strike
      @current_frame += 1
    else @current_roll += 1
    end
  end

  def roll_2(pins)
    roll_1 = @roll_scores[@current_frame - 1][0]
    raise 'Max pins exceeded, recheck and try again' if pins + roll_1 > 10

    @roll_scores[@current_frame - 1] << pins
    normal_scoring(pins)
    strike_scoring(pins) if @frame_bonus_type[@current_frame - 2] == :strike
    @frame_bonus_type[@current_frame - 1] = :spare if pins + roll_1 == 10
    @current_frame += 1
    @current_roll = 1
  end

  def current_score
    @frame_scores.sum
  end

  def final_score
    raise 'You have not bowled 10 frames yet' if game_over? == false

    current_score
  end

  def game_over?
    @current_frame > 10
  end

  def normal_scoring(pins)
    @frame_scores[@current_frame - 1] += pins
  end

  def spare_scoring(spare_bonus)
    @frame_scores[@current_frame - 2] += spare_bonus
  end

  def strike_scoring(strike_bonus)
    @frame_scores[@current_frame - 2] += strike_bonus
  end

  def chain_strike_scoring(strike_bonus)
    @frame_scores[@current_frame - 3] += strike_bonus
  end
end
