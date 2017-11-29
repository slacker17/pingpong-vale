class HomeController < ApplicationController

  # Loardboard
  def index
    # Get all users
    @au = User.all
    # Auxiliar list to save users (sorted)
    lista = []
    # Iteration
    @au.each do |u|
      lista << [u.email, u.logs.sum(:score), u.logs.count]
    end
    # Order the list according with the sum of their scores
    @fl = lista.sort{|a,b| b[1] <=> a[1]}
  end

  # User's History
  def history
    @user_id_logged = current_user.id       # Get id user logged
    @user = User.find(id=@user_id_logged)   # Get User from database
    @ul = @user.logs                        # Get Logs belong to user 
    @lista = []                              # Auliar list
    
    @ul.each do |u|                         # Iteration of logs
      @gam = Game.find(id=u.game_id)        # Get game (relationship with model game)
      @logs2 = @gam.logs                    # Get logs belont to game
      aux = 0                               # Auxiliar to save the other log (opponent)
      @logs2.each do |u2|                   # Iteration to find it
        if u2.user_id != @user_id_logged    # If find the opponent_id in logs 
          aux = u2                          # Get the log of the opponent (to get its score)
        end
      end
      @oponente = User.find(id=aux.user_id) # Get data of the opponent

      # Add data to to auxiliar list to show it
      @lista << [@gam.date, @oponente.email, u.score, aux.score]
    end
  end

  def log
  end

  # Create a new Game and a new Log
  def create
    # Get date (for table game)
    date = params[:start_date]['year']+'-'+params[:start_date]['month']+'-'+params[:start_date]['day'] if params[:start_date]
    # Get Opponent id (for the table log)
    opponent_id = params[:opponent_id] if params[:opponent_id]
    # Get Score (user_logged, for the table log)
    your_score = params[:your_score]['your_score'] if params[:your_score]['your_score']
    # Get Their Score (Score of the opponent for the table log)
    their_score = params[:their_score]['their_score'] if params[:their_score]['their_score']
    
    #Save new Game
    new_game = Game.create :date => date
    
    #Save Score (Your score) in table Log
    new_log_your = Log.create :score => your_score, :user_id => current_user.id, :game_id => new_game.id
    
    #Save Score (Their score) in table Log (for the opponent)
    new_log_their = Log.create :score => their_score, :user_id => opponent_id, :game_id => new_game.id

    redirect_to '/index'
  end
  
end
