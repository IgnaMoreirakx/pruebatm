class SocialController < ApplicationController

  def index
    if user_signed_in? && current_user.rol == 3 && current_user.accept_model == true
    else
      redirect_to root_path
    end
  end

  def test
    if user_signed_in? && current_user.rol == 3 && current_user.accept_model == true
      @my_course = Course.find(params[:id])
      if current_user.tests.find_by(kind: 2, answered: true, course_id: @my_course.id).present?
        if current_user.tests.find_by(kind: 3, answered: true, course_id: @my_course.id).present?
          redirect_to test_social_path, notice: "Tests ya respondidos"
        else
          allPartners = User.joins(:courses).where(courses: { id: @my_course.id }, rol: 3).where.not(id: current_user.id)
          answers = current_user.tests.find_by(kind: 2, answered: true, course_id: @my_course.id).answers
          existA = 0
          existB = 0
          @partnersA = [] 
          @partnersB = []
          allPartners.each do |p|
            answers.each do |a|
              if p.id == a.number
                if a.answer == 1
                  existA = 1
                end
                if a.answer == 0
                  existB = 1
                end
              end
            end
            if existA != 1
              @partnersA << p
            end
            if existB != 1
              @partnersB << p
            end
            existA = 0
            existB = 0
          end
        end
      else  
        @partners = User.joins(:courses).where(courses: { id: @my_course.id }, rol: 3).where.not(id: current_user.id)
      end
    else
      redirect_to root_path
    end
  end

  def create
   if user_signed_in? && current_user.rol == 3 && current_user.accept_model == true
      @my_course = Course.find(params[:id])
      if current_user.tests.find_by(kind: 2, answered: true, course_id: @my_course.id).present?
        test_now = current_user.tests.find_by(kind: 3, course_id: @my_course.id)
        type_test = 0
      else
        test_now = current_user.tests.find_by(kind: 2, course_id: @my_course.id)
        type_test = 1
      end

      partnersA = params[:partnersA]
      partnersB = params[:partnersB]

      #datos primera pregunta
      if partnersA != nil
        partnersA.each do |partner|
          Answer.create(test_id: test_now.id , element_kind: type_test, number: partner, answer: 1)
        end
      end

      #datos segunda pregunta
      if partnersB != nil
        partnersB.each do |partner|
          Answer.create(test_id: test_now.id , element_kind: type_test, number: partner, answer: 0)
        end
      end

      if test_now.update(:answered => true)
        if test_now.kind == 2
          redirect_to "/test_social/#{@my_course.id}/test", notice: "Test realizado con éxito"   
        else
          redirect_to "/test_social/#{@my_course.id}", notice: "Test realizado con éxito"   
        end
      else
        redirect_back(fallback_location: test_social_path, alert: "No se ha podido procesar la solicitud") 
      end
    end
  end

  def test_course
    @course = Course.find(params[:id]) 
  end

end
