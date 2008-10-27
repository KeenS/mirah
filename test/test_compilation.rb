require 'duby'
require 'duby/compiler'
require 'test/unit'
require 'jruby'

class TestAst < Test::Unit::TestCase
  include Duby
  
  class MockCompiler
    attr_accessor :calls
    
    def initialize
      @calls = []
    end
    def compile(ast)
      ast.compile(self, true)
    end
    
    def method_missing(sym, *args, &block)
      calls << [sym, *args]
      block.call if block
    end
  end
  
  def setup
    @compiler = MockCompiler.new
  end
  
  def test_fixnum
    new_ast = AST.parse("1").body
    
    new_ast.compile(@compiler, true)
    
    assert_equal([[:fixnum, 1]], @compiler.calls)
  end
  
  def test_string
    new_ast = AST.parse("'foo'").body
    
    new_ast.compile(@compiler, true)
    
    assert_equal([[:string, "foo"]], @compiler.calls)
  end
  
  def test_float
    new_ast = AST.parse("1.0").body
    
    new_ast.compile(@compiler, true)
    
    assert_equal([[:float, 1.0]], @compiler.calls)
  end
  
  def test_boolean
    new_ast = AST.parse("true").body
    
    new_ast.compile(@compiler, true)
    
    assert_equal([[:boolean, true]], @compiler.calls)
  end
  
  def test_local
    new_ast = AST.parse("a = 1; a").body
    
    new_ast.compile(@compiler, true)
    
    assert_equal([[:local_assign, "a", nil, false], [:fixnum, 1], [:local, "a", nil]], @compiler.calls)
  end
  
  def test_local_typed
    new_ast = AST.parse("a = 1; a").body
    typer = Typer::Simple.new(:bar)
    new_ast.infer(typer)
    new_ast.compile(@compiler, true)
    
    assert_equal([[:local_assign, "a", AST.type(:fixnum), false], [:fixnum, 1], [:local, "a", AST.type(:fixnum)]], @compiler.calls)
  end
end