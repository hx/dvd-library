module FindByScopeSet

  def find_by_scope_set(scope_set)

    scope_set = TitleScopeSet.new scope_set unless scope_set.respond_to? :by_type

    ret = select(:id)

    scope_set.by_type(:search).each do |scope|
      ret = ret.where arel_table[:title].matches "%#{scope.term}%"
    end

    scope_set.by_type(:filter, :person).each do |scope|
      if %w[studio media-type genre person].include? scope.property

        # name of the filter property's table, eg :studios
        scope_table_name = scope.property.gsub('-', '_').pluralize.to_sym

        # class of the filter property, eg Studio
        scope_class = reflections[scope_table_name].klass

        # name of the relevant join table, eg :studio_involvements
        join_table_name = reflections[scope_table_name].options[:through]

        # arel table for the relevant join table, eg studio_involvements
        join_table_arel = reflections[join_table_name].klass.arel_table

        # key in join table to identify titles, eg :title_id
        join_table_title_key = reflections[join_table_name].foreign_key

        # key in join table that must match given scope, eg :studio_id
        join_table_scope_key = scope_class.reflections[join_table_name].foreign_key.to_sym

        # SELECT clause of subquery, eg SELECT title_id FROM "studio_involvements"
        subquery = join_table_arel.project join_table_title_key

        # WHERE clause of subquery, eg WHERE "studio_involvements"."studio_id" = 29
        subquery = subquery.where join_table_arel[join_table_scope_key].eq scope.value.to_i

        # the resulting WHERE clause specifying titles with their id IN the subquery
        ret = ret.where id: subquery

      elsif scope.property == 'runtime'

        field = arel_table[:runtime]
        ret = ret.where(field.gteq scope[:min]).where(field.lteq scope[:max])

      elsif scope.respond_to? :comparison

        ret = ret.where arel_table[scope.property.gsub('-', '_').to_s].send(AREL_COMPARISON_METHODS[scope.comparison], scope.value)

      else

        ret = ret.where scope.property.to_s => scope.value

      end
    end

    sorts = scope_set.by_type :sort
    sorts.each do |scope|
      ret = ret.order '%s %s' % [SORT_FIELDS[scope.criteria] || scope.criteria.gsub('-', '_'), scope.reverse ? 'DESC' : 'ASC']
    end
    ret = ret.order :sort_title if sorts.empty?

    ret
  end

  private

    AREL_COMPARISON_METHODS = {
        ''    => :eq,
        'lt'  => :lt,
        'gt'  => :gt,
        'lte' => :lteq,
        'gte' => :gteq
    }

    SORT_FIELDS = {
        'title' => 'sort_title'
    }

end