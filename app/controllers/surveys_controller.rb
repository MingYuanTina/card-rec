class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
   
    # get card and make matches and store those in instance variable 
    @card = params[:card_id] ? Card.find(params[:card_id]) : Card.order("RANDOM()").first
    @card.initialize_matches_and_mark_best_scores unless @card.matches.any? 
    @matches = @card.best_matches.order(:rule_id)

    @survey = Survey.new
  end

  def specific
    card_id = params[:card_id]

    redirect_to action: 'new', card_id: card_id
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    # { survey: { card_id: 123, responses: [{ match_id: 5, selected: true}, {match_id: 1, selected: false} ... ] } }
    # check_box name: "responses[]" 

    card = Card.find(survey_params[:card_id])
    @survey = Survey.create(card)
    survey_params[:responses].each do |r|
      @survey.responses.create(match_id: r.match_id, selected: r.selected)
    end
    # OR
    # @survey.init_responses(survey_params[:responses])


    # @survey = Survey.new(survey_params)

    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:card_id, :responses)
    end
end
