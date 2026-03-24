(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun R (Real) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %R (Poly) Real)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const REAL Type)
(declare-const CHAR Type)
(declare-const USIZE Type)
(declare-const ISIZE Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun FLOAT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-fun CONST_BOOL (Bool) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-const $slice Dcr)
(declare-const $dyn Dcr)
(declare-fun DST (Dcr) Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun MUTREF (Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun sized (Dcr) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(declare-fun const_bool (Type) Bool)
(declare-fun mut_ref_current% (Poly) Poly)
(declare-fun mut_ref_future% (Poly) Poly)
(declare-fun mut_ref_update_current% (Poly Poly) Poly)
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_current% (mut_ref_update_current% m arg)) arg)
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_current
   :skolemid skolem_prelude_mut_ref_update_current_current
)))
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_future% (mut_ref_update_current% m arg)) (mut_ref_future% m))
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_future
   :skolemid skolem_prelude_mut_ref_update_current_future
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_current% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_current% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_future% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_future% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type) (arg Poly)) (!
   (=>
    (and
     (has_type m (MUTREF d t))
     (has_type arg t)
    )
    (has_type (mut_ref_update_current% m arg) (MUTREF d t))
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_has_type
   :skolemid skolem_prelude_mut_ref_update_has_type
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (sized (DST d))
   )
   :pattern ((sized (DST d)))
   :qid prelude_sized_decorate_struct_inherit
   :skolemid skolem_prelude_sized_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (sized (REF d))
   :pattern ((sized (REF d)))
   :qid prelude_sized_decorate_ref
   :skolemid skolem_prelude_sized_decorate_ref
)))
(assert
 (forall ((d Dcr)) (!
   (sized (MUT_REF d))
   :pattern ((sized (MUT_REF d)))
   :qid prelude_sized_decorate_mut_ref
   :skolemid skolem_prelude_sized_decorate_mut_ref
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (BOX d t d2))
   :pattern ((sized (BOX d t d2)))
   :qid prelude_sized_decorate_box
   :skolemid skolem_prelude_sized_decorate_box
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (RC d t d2))
   :pattern ((sized (RC d t d2)))
   :qid prelude_sized_decorate_rc
   :skolemid skolem_prelude_sized_decorate_rc
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (ARC d t d2))
   :pattern ((sized (ARC d t d2)))
   :qid prelude_sized_decorate_arc
   :skolemid skolem_prelude_sized_decorate_arc
)))
(assert
 (forall ((d Dcr)) (!
   (sized (GHOST d))
   :pattern ((sized (GHOST d)))
   :qid prelude_sized_decorate_ghost
   :skolemid skolem_prelude_sized_decorate_ghost
)))
(assert
 (forall ((d Dcr)) (!
   (sized (TRACKED d))
   :pattern ((sized (TRACKED d)))
   :qid prelude_sized_decorate_tracked
   :skolemid skolem_prelude_sized_decorate_tracked
)))
(assert
 (forall ((d Dcr)) (!
   (sized (NEVER d))
   :pattern ((sized (NEVER d)))
   :qid prelude_sized_decorate_never
   :skolemid skolem_prelude_sized_decorate_never
)))
(assert
 (forall ((d Dcr)) (!
   (sized (CONST_PTR d))
   :pattern ((sized (CONST_PTR d)))
   :qid prelude_sized_decorate_const_ptr
   :skolemid skolem_prelude_sized_decorate_const_ptr
)))
(assert
 (sized $)
)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (= b (const_bool (CONST_BOOL b)))
   :pattern ((CONST_BOOL b))
   :qid prelude_type_id_const_bool
   :skolemid skolem_prelude_type_id_const_bool
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((r Real)) (!
   (has_type (R r) REAL)
   :pattern ((has_type (R r) REAL))
   :qid prelude_has_type_real
   :skolemid skolem_prelude_has_type_real
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Real)) (!
   (= x (%R (R x)))
   :pattern ((R x))
   :qid prelude_unbox_box_real
   :skolemid skolem_prelude_unbox_box_real
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_box_unbox_usize
   :skolemid skolem_prelude_box_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_box_unbox_isize
   :skolemid skolem_prelude_box_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x REAL)
    (= x (R (%R x)))
   )
   :pattern ((has_type x REAL))
   :qid prelude_box_unbox_real
   :skolemid skolem_prelude_box_unbox_real
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((x Int)) (!
   (=>
    (uInv SZ x)
    (has_type (I x) USIZE)
   )
   :pattern ((has_type (I x) USIZE))
   :qid prelude_has_type_usize
   :skolemid skolem_prelude_has_type_usize
)))
(assert
 (forall ((x Int)) (!
   (=>
    (iInv SZ x)
    (has_type (I x) ISIZE)
   )
   :pattern ((has_type (I x) ISIZE))
   :qid prelude_has_type_isize
   :skolemid skolem_prelude_has_type_isize
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (FLOAT bits))
   )
   :pattern ((has_type (I x) (FLOAT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (uInv SZ (%I x))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_unbox_usize
   :skolemid skolem_prelude_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (iInv SZ (%I x))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_unbox_isize
   :skolemid skolem_prelude_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(declare-fun RAdd (Real Real) Real)
(declare-fun RSub (Real Real) Real)
(declare-fun RMul (Real Real) Real)
(declare-fun RDiv (Real Real) Real)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RAdd x y) (+ x y))
   :pattern ((RAdd x y))
   :qid prelude_radd
   :skolemid skolem_prelude_radd
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RSub x y) (- x y))
   :pattern ((RSub x y))
   :qid prelude_rsub
   :skolemid skolem_prelude_rsub
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RMul x y) (* x y))
   :pattern ((RMul x y))
   :qid prelude_rmul
   :skolemid skolem_prelude_rmul
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RDiv x y) (/ x y))
   :pattern ((RDiv x y))
   :qid prelude_rdiv
   :skolemid skolem_prelude_rdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun has_resolved (Dcr Type Poly) Bool)
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun default_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'module lemmas::scalar_lemmas_::naf_lemmas'
;; curve25519-dalek/src/lemmas/scalar_lemmas_/naf_lemmas.rs:266:1: 274:2 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.impl&%0.take. FuelId)
(declare-const fuel%vstd!seq.impl&%0.skip. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_index. FuelId)
(declare-const fuel%vstd!seq.lemma_seq_two_subranges_index. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.reconstruct. FuelId)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!function.group_function_axioms. FuelId)
(declare-const fuel%vstd!laws_cmp.group_laws_cmp. FuelId)
(declare-const fuel%vstd!laws_eq.bool_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.usize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.isize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.group_laws_eq. FuelId)
(declare-const fuel%vstd!layout.group_layout_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_filter_ensures. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_default. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms. FuelId)
(declare-const fuel%vstd!std_specs.hash.group_hash_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.
  fuel%vstd!arithmetic.div_mod.lemma_mod_mod. fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. fuel%vstd!seq.impl&%0.spec_index.
  fuel%vstd!seq.impl&%0.take. fuel%vstd!seq.impl&%0.skip. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_subrange_decreases. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!seq.axiom_seq_subrange_len. fuel%vstd!seq.axiom_seq_subrange_index. fuel%vstd!seq.lemma_seq_two_subranges_index.
  fuel%curve25519_dalek!specs.scalar_specs.reconstruct. fuel%vstd!array.group_array_axioms.
  fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp. fuel%vstd!laws_eq.bool_laws.group_laws_eq.
  fuel%vstd!laws_eq.u8_laws.group_laws_eq. fuel%vstd!laws_eq.i8_laws.group_laws_eq.
  fuel%vstd!laws_eq.u16_laws.group_laws_eq. fuel%vstd!laws_eq.i16_laws.group_laws_eq.
  fuel%vstd!laws_eq.u32_laws.group_laws_eq. fuel%vstd!laws_eq.i32_laws.group_laws_eq.
  fuel%vstd!laws_eq.u64_laws.group_laws_eq. fuel%vstd!laws_eq.i64_laws.group_laws_eq.
  fuel%vstd!laws_eq.u128_laws.group_laws_eq. fuel%vstd!laws_eq.i128_laws.group_laws_eq.
  fuel%vstd!laws_eq.usize_laws.group_laws_eq. fuel%vstd!laws_eq.isize_laws.group_laws_eq.
  fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms. fuel%vstd!map.group_map_axioms.
  fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_filter_ensures. fuel%vstd!seq_lib.group_seq_lib_default.
  fuel%vstd!set.group_set_axioms. fuel%vstd!set_lib.group_set_lib_default. fuel%vstd!slice.group_slice_axioms.
  fuel%vstd!string.group_string_axioms. fuel%vstd!std_specs.bits.group_bits_axioms.
  fuel%vstd!std_specs.control_flow.group_control_flow_axioms. fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.
  fuel%vstd!std_specs.hash.group_hash_axioms. fuel%vstd!std_specs.range.group_range_axioms.
  fuel%vstd!std_specs.slice.group_slice_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
  (and
   (fuel_bool_default fuel%vstd!laws_eq.bool_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.usize_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.isize_laws.group_laws_eq.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_index.)
   (fuel_bool_default fuel%vstd!seq.lemma_seq_two_subranges_index.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_default.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!function.group_function_axioms.)
   (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_cmp.group_laws_cmp.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
   (fuel_bool_default fuel%vstd!layout.group_layout_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.hash.group_hash_axioms.)
)))

;; Datatypes
(declare-sort vstd!seq.Seq<i8.>. 0)
(declare-datatypes ((tuple%0. 0)) (((tuple%0./tuple%0))))
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun Poly%vstd!seq.Seq<i8.>. (vstd!seq.Seq<i8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<i8.>. (Poly) vstd!seq.Seq<i8.>.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(assert
 (forall ((x vstd!seq.Seq<i8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<i8.>. (Poly%vstd!seq.Seq<i8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<i8.>. x))
   :qid internal_vstd__seq__Seq<i8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (SINT 8)))
    (= x (Poly%vstd!seq.Seq<i8.>. (%Poly%vstd!seq.Seq<i8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (SINT 8))))
   :qid internal_vstd__seq__Seq<i8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<i8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<i8.>. x) (TYPE%vstd!seq.Seq. $ (SINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<i8.>. x) (TYPE%vstd!seq.Seq. $ (SINT 8))))
   :qid internal_vstd__seq__Seq<i8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_has_type_always_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::subrange
(declare-fun vstd!seq.Seq.subrange.? (Dcr Type Poly Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::std_specs::num::i8_specs::wrapping_sub%returns_clause_autospec
(declare-fun vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.? (Poly
  Poly
 ) Int
)

;; Function-Decl vstd::seq::impl&%0::take
(declare-fun vstd!seq.impl&%0.take.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::skip
(declare-fun vstd!seq.impl&%0.skip.? (Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::specs::scalar_specs::reconstruct
(declare-fun curve25519_dalek!specs.scalar_specs.reconstruct.? (Poly) Int)
(declare-fun curve25519_dalek!specs.scalar_specs.rec%reconstruct.? (Poly Fuel) Int)

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%0
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%1
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_0
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_0
))))

;; Function-Specs vstd::seq::Seq::subrange
(declare-fun req%vstd!seq.Seq.subrange. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (= (req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!) (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I start_inclusive!)))
      (let
       ((tmp%%$1 (%I end_exclusive!)))
       (and
        (and
         (<= 0 tmp%%$)
         (<= tmp%%$ tmp%%$1)
        )
        (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& self!))
   )))))
   :pattern ((req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_req__vstd!seq.Seq.subrange._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.subrange._definition
)))

;; Function-Axioms vstd::seq::Seq::subrange
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type start_inclusive! INT)
     (has_type end_exclusive! INT)
    )
    (has_type (vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!) (
      TYPE%vstd!seq.Seq. A&. A&
   )))
   :pattern ((vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_vstd!seq.Seq.subrange.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.subrange.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_subrange_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type j! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I i!)))
         (let
          ((tmp%%$1 (%I j!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (< (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (vstd!seq.Seq.len.?
         A&. A& s!
      )))
      (height_lt (height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)))
    :qid user_vstd__seq__axiom_seq_subrange_decreases_1
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_decreases_1
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
          ))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_2
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_2
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_3
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_3
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
              i$
          ))))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_4
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_4
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_5
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_5
))))

;; Broadcast vstd::seq::axiom_seq_subrange_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I j!)))
        (let
         ((tmp%%$1 (%I k!)))
         (and
          (and
           (<= 0 tmp%%$)
           (<= tmp%%$ tmp%%$1)
          )
          (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
      ))))
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)) (Sub (%I k!)
        (%I j!)
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)))
    :qid user_vstd__seq__axiom_seq_subrange_len_6
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_6
))))

;; Broadcast vstd::seq::axiom_seq_subrange_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I j!)))
         (let
          ((tmp%%$1 (%I k!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!) (vstd!seq.Seq.index.?
        A&. A& s! (I (Add (%I i!) (%I j!)))
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!))
    :qid user_vstd__seq__axiom_seq_subrange_index_7
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_7
))))

;; Broadcast vstd::seq::lemma_seq_two_subranges_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.lemma_seq_two_subranges_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k1! Poly) (k2! Poly) (i! Poly))
   (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k1! INT)
      (has_type k2! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (and
         (and
          (sized A&.)
          (let
           ((tmp%%$ (%I j!)))
           (let
            ((tmp%%$1 (%I k1!)))
            (and
             (and
              (<= 0 tmp%%$)
              (<= tmp%%$ tmp%%$1)
             )
             (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
         ))))
         (let
          ((tmp%%$ (%I j!)))
          (let
           ((tmp%%$3 (%I k2!)))
           (and
            (and
             (<= 0 tmp%%$)
             (<= tmp%%$ tmp%%$3)
            )
            (<= tmp%%$3 (vstd!seq.Seq.len.? A&. A& s!))
        ))))
        (let
         ((tmp%%$ (%I i!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (Sub (%I k1!) (%I j!)))
       )))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k2!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!) (vstd!seq.Seq.index.?
        A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k2!) i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!)
     (vstd!seq.Seq.subrange.? A&. A& s! j! k2!)
    )
    :qid user_vstd__seq__lemma_seq_two_subranges_index_8
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_8
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%3
     (not (= d! 0))
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (= x! (Add (Mul d!
       (EucDiv x! d!)
      ) (EucMod x! d!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.)
  (forall ((x! Int) (d! Int)) (!
    (=>
     (not (= d! 0))
     (= x! (Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    )
    :pattern ((Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_9
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_9
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod_converse
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. (Int Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q! r!) (
     and
     (=>
      %%global_location_label%%4
      (not (= d! 0))
     )
     (=>
      %%global_location_label%%5
      (let
       ((tmp%%$ r!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
     )))
     (=>
      %%global_location_label%%6
      (= x! (Add (Mul q! d!) r!))
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q!
     r!
   ))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. (Int Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q! r!) (
     and
     (= r! (EucMod x! d!))
     (= q! (EucDiv x! d!))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q!
     r!
   ))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
)))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_mod. (Int Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!) (and
     (=>
      %%global_location_label%%7
      (< 0 a!)
     )
     (=>
      %%global_location_label%%8
      (< 0 b!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_mod. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!) (and
     (< 0 (Mul a! b!))
     (= (EucMod (EucMod x! (Mul a! b!)) a!) (EucMod x! a!))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_mod.)
  (forall ((x! Int) (a! Int) (b! Int)) (!
    (=>
     (and
      (< 0 a!)
      (< 0 b!)
     )
     (and
      (< 0 (Mul a! b!))
      (= (EucMod (EucMod x! (Mul a! b!)) a!) (EucMod x! a!))
    ))
    :pattern ((EucMod (EucMod x! (Mul a! b!)) a!) (EucMod x! a!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_mod_10
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_mod_10
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_breakdown
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_breakdown. (Int Int Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!) (and
     (=>
      %%global_location_label%%9
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%10
      (< 0 y!)
     )
     (=>
      %%global_location_label%%11
      (< 0 z!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!) (and
     (> (Mul y! z!) 0)
     (= (EucMod x! (Mul y! z!)) (Add (Mul y! (EucMod (EucDiv x! y!) z!)) (EucMod x! y!)))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_breakdown
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (and
       (<= 0 x!)
       (< 0 y!)
      )
      (< 0 z!)
     )
     (and
      (> (Mul y! z!) 0)
      (= (EucMod x! (Mul y! z!)) (Add (Mul y! (EucMod (EucDiv x! y!) z!)) (EucMod x! y!)))
    ))
    :pattern ((EucMod x! (Mul y! z!)))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_breakdown_11
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_breakdown_11
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics. x!) (and
     (= (Mul 0 x!) 0)
     (= (Mul x! 0) 0)
     (= (Mul x! 1) x!)
     (= (Mul 1 x!) x!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
)))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_associative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_associative. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!) (= (Mul x! (Mul y! z!))
     (Mul (Mul x! y!) z!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_associative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_associative.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Mul y! z!)) (Mul (Mul x! y!) z!))
    :pattern ((Mul x! (Mul y! z!)))
    :pattern ((Mul (Mul x! y!) z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_12
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_12
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_commutative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_commutative. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!) (= (Mul x! y!) (Mul y!
      x!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_commutative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.)
  (forall ((x! Int) (y! Int)) (!
    (= (Mul x! y!) (Mul y! x!))
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_13
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_13
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_add
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. x! y! z!) (= (Mul x! (Add
       y! z!
      )
     ) (Add (Mul x! y!) (Mul x! z!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_add
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Add y! z!)) (Add (Mul x! y!) (Mul x! z!)))
    :pattern ((Mul x! (Add y! z!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_14
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_14
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_add_other_way
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. x! y! z!) (= (
      Mul (Add y! z!) x!
     ) (Add (Mul y! x!) (Mul z! x!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_add_other_way
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul (Add y! z!) x!) (Add (Mul y! x!) (Mul z! x!)))
    :pattern ((Mul (Add y! z!) x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_15
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_15
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_sub
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. x! y! z!) (= (Mul x! (Sub
       y! z!
      )
     ) (Sub (Mul x! y!) (Mul x! z!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_sub
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Sub y! z!)) (Sub (Mul x! y!) (Mul x! z!)))
    :pattern ((Mul x! (Sub y! z!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_16
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_16
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_sub_other_way
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. x! y! z!) (= (
      Mul (Sub y! z!) x!
     ) (Sub (Mul y! x!) (Mul z! x!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_sub_other_way
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul (Sub y! z!) x!) (Sub (Mul y! x!) (Mul z! x!)))
    :pattern ((Mul (Sub y! z!) x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_17
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_17
))))

;; Function-Axioms vstd::arithmetic::power2::pow2
(assert
 (forall ((e! Poly)) (!
   (=>
    (has_type e! NAT)
    (<= 0 (vstd!arithmetic.power2.pow2.? e!))
   )
   :pattern ((vstd!arithmetic.power2.pow2.? e!))
   :qid internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
   :skolemid skolem_internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
)))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_pos
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_pos. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_pos. e!) (> (vstd!arithmetic.power2.pow2.?
      (I e!)
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_pos. e!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_pos
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_pos.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (> (vstd!arithmetic.power2.pow2.? e!) 0)
    )
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_18
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_18
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_adds
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_adds. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_adds. e1! e2!) (= (vstd!arithmetic.power2.pow2.?
      (I (nClip (Add e1! e2!)))
     ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I e1!)) (vstd!arithmetic.power2.pow2.?
        (I e2!)
   )))))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_adds. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_adds._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_adds._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_adds
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_adds.)
  (forall ((e1! Int) (e2! Int)) (!
    (=>
     (and
      (<= 0 e1!)
      (<= 0 e2!)
     )
     (= (vstd!arithmetic.power2.pow2.? (I (nClip (Add e1! e2!)))) (nClip (Mul (vstd!arithmetic.power2.pow2.?
         (I e1!)
        ) (vstd!arithmetic.power2.pow2.? (I e2!))
    ))))
    :pattern ((vstd!arithmetic.power2.pow2.? (I (nClip (Add e1! e2!)))))
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_19
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_19
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_strictly_increases
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%12
     (< e1! e2!)
   ))
   :pattern ((req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!))
   :qid internal_req__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
)))
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (< (vstd!arithmetic.power2.pow2.?
      (I e1!)
     ) (vstd!arithmetic.power2.pow2.? (I e2!))
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_strictly_increases
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.)
  (forall ((e1! Poly) (e2! Poly)) (!
    (=>
     (and
      (has_type e1! NAT)
      (has_type e2! NAT)
     )
     (=>
      (< (%I e1!) (%I e2!))
      (< (vstd!arithmetic.power2.pow2.? e1!) (vstd!arithmetic.power2.pow2.? e2!))
    ))
    :pattern ((vstd!arithmetic.power2.pow2.? e1!) (vstd!arithmetic.power2.pow2.? e2!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_20
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_20
))))

;; Function-Specs vstd::arithmetic::power2::lemma2_to64
(declare-fun ens%vstd!arithmetic.power2.lemma2_to64. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma2_to64. no%param) (and
     (= (vstd!arithmetic.power2.pow2.? (I 0)) 1)
     (= (vstd!arithmetic.power2.pow2.? (I 1)) 2)
     (= (vstd!arithmetic.power2.pow2.? (I 2)) 4)
     (= (vstd!arithmetic.power2.pow2.? (I 3)) 8)
     (= (vstd!arithmetic.power2.pow2.? (I 4)) 16)
     (= (vstd!arithmetic.power2.pow2.? (I 5)) 32)
     (= (vstd!arithmetic.power2.pow2.? (I 6)) 64)
     (= (vstd!arithmetic.power2.pow2.? (I 7)) 128)
     (= (vstd!arithmetic.power2.pow2.? (I 8)) 256)
     (= (vstd!arithmetic.power2.pow2.? (I 9)) 512)
     (= (vstd!arithmetic.power2.pow2.? (I 10)) 1024)
     (= (vstd!arithmetic.power2.pow2.? (I 11)) 2048)
     (= (vstd!arithmetic.power2.pow2.? (I 12)) 4096)
     (= (vstd!arithmetic.power2.pow2.? (I 13)) 8192)
     (= (vstd!arithmetic.power2.pow2.? (I 14)) 16384)
     (= (vstd!arithmetic.power2.pow2.? (I 15)) 32768)
     (= (vstd!arithmetic.power2.pow2.? (I 16)) 65536)
     (= (vstd!arithmetic.power2.pow2.? (I 17)) 131072)
     (= (vstd!arithmetic.power2.pow2.? (I 18)) 262144)
     (= (vstd!arithmetic.power2.pow2.? (I 19)) 524288)
     (= (vstd!arithmetic.power2.pow2.? (I 20)) 1048576)
     (= (vstd!arithmetic.power2.pow2.? (I 21)) 2097152)
     (= (vstd!arithmetic.power2.pow2.? (I 22)) 4194304)
     (= (vstd!arithmetic.power2.pow2.? (I 23)) 8388608)
     (= (vstd!arithmetic.power2.pow2.? (I 24)) 16777216)
     (= (vstd!arithmetic.power2.pow2.? (I 25)) 33554432)
     (= (vstd!arithmetic.power2.pow2.? (I 26)) 67108864)
     (= (vstd!arithmetic.power2.pow2.? (I 27)) 134217728)
     (= (vstd!arithmetic.power2.pow2.? (I 28)) 268435456)
     (= (vstd!arithmetic.power2.pow2.? (I 29)) 536870912)
     (= (vstd!arithmetic.power2.pow2.? (I 30)) 1073741824)
     (= (vstd!arithmetic.power2.pow2.? (I 31)) 2147483648)
     (= (vstd!arithmetic.power2.pow2.? (I 32)) 4294967296)
     (= (vstd!arithmetic.power2.pow2.? (I 64)) 18446744073709551616)
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma2_to64. no%param))
   :qid internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
)))

;; Function-Axioms vstd::std_specs::num::i8_specs::wrapping_sub%returns_clause_autospec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.? x! y!) (ite
      (> (Sub (%I x!) (%I y!)) 127)
      (iClip 8 (Sub (Sub (%I x!) (%I y!)) 256))
      (ite
       (< (Sub (%I x!) (%I y!)) (- 128))
       (iClip 8 (Add (Sub (%I x!) (%I y!)) 256))
       (iClip 8 (Sub (%I x!) (%I y!)))
    )))
    :pattern ((vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.? x! y!))
    :qid internal_vstd!std_specs.num.i8_specs.wrapping_sub__returns_clause_autospec.?_definition
    :skolemid skolem_internal_vstd!std_specs.num.i8_specs.wrapping_sub__returns_clause_autospec.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! (SINT 8))
     (has_type y! (SINT 8))
    )
    (iInv 8 (vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.? x! y!))
   )
   :pattern ((vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.? x! y!))
   :qid internal_vstd!std_specs.num.i8_specs.wrapping_sub__returns_clause_autospec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.num.i8_specs.wrapping_sub__returns_clause_autospec.?_pre_post_definition
)))

;; Function-Axioms vstd::seq::impl&%0::take
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.take.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.take.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
    (= (vstd!seq.impl&%0.take.? A&. A& self! n!) (vstd!seq.Seq.subrange.? A&. A& self!
      (I 0) n!
    ))
    :pattern ((vstd!seq.impl&%0.take.? A&. A& self! n!))
    :qid internal_vstd!seq.impl&__0.take.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.take.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type n! INT)
    )
    (has_type (vstd!seq.impl&%0.take.? A&. A& self! n!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.impl&%0.take.? A&. A& self! n!))
   :qid internal_vstd!seq.impl&__0.take.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.take.?_pre_post_definition
)))

;; Function-Axioms vstd::seq::impl&%0::skip
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.skip.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.skip.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
    (= (vstd!seq.impl&%0.skip.? A&. A& self! n!) (vstd!seq.Seq.subrange.? A&. A& self!
      n! (I (vstd!seq.Seq.len.? A&. A& self!))
    ))
    :pattern ((vstd!seq.impl&%0.skip.? A&. A& self! n!))
    :qid internal_vstd!seq.impl&__0.skip.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.skip.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type n! INT)
    )
    (has_type (vstd!seq.impl&%0.skip.? A&. A& self! n!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.impl&%0.skip.? A&. A& self! n!))
   :qid internal_vstd!seq.impl&__0.skip.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.skip.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::reconstruct
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.reconstruct.)
)
(declare-const fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct. Fuel)
(assert
 (forall ((naf! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! fuel%) (curve25519_dalek!specs.scalar_specs.rec%reconstruct.?
     naf! zero
   ))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! fuel%))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_zero_definition
)))
(assert
 (forall ((naf! Poly) (fuel% Fuel)) (!
   (=>
    (has_type naf! (TYPE%vstd!seq.Seq. $ (SINT 8)))
    (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! (succ fuel%)) (ite
      (= (vstd!seq.Seq.len.? $ (SINT 8) naf!) 0)
      0
      (Add (%I (vstd!seq.Seq.index.? $ (SINT 8) naf! (I 0))) (Mul 2 (curve25519_dalek!specs.scalar_specs.rec%reconstruct.?
         (vstd!seq.Seq.subrange.? $ (SINT 8) naf! (I 1) (I (vstd!seq.Seq.len.? $ (SINT 8) naf!)))
         fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! (succ fuel%)))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.reconstruct.)
  (forall ((naf! Poly)) (!
    (=>
     (has_type naf! (TYPE%vstd!seq.Seq. $ (SINT 8)))
     (= (curve25519_dalek!specs.scalar_specs.reconstruct.? naf!) (curve25519_dalek!specs.scalar_specs.rec%reconstruct.?
       naf! (succ fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct.)
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.reconstruct.? naf!))
    :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct.?_definition
))))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u64_shift_is_pow2
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
 (Int) Bool
)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
    ) (=>
     %%global_location_label%%13
     (< k! 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
 (Int) Bool
)
(assert
 (forall ((k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
    ) (= (uClip 64 (bitshl (I (uClip 64 1)) (I k!))) (vstd!arithmetic.power2.pow2.? (I k!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_width_properties
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties.
 (Int) Bool
)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((w! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties.
     w!
    ) (=>
     %%global_location_label%%14
     (let
      ((tmp%%$ w!))
      (and
       (<= 2 tmp%%$)
       (<= tmp%%$ 8)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties.
     w!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties.
 (Int) Bool
)
(assert
 (forall ((w! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties.
     w!
    ) (and
     (= (uClip 64 (bitshl (I 1) (I (uClip 64 w!)))) (vstd!arithmetic.power2.pow2.? (I w!)))
     (>= (uClip 64 (bitshl (I 1) (I (uClip 64 w!)))) 4)
     (<= (uClip 64 (bitshl (I 1) (I (uClip 64 w!)))) 256)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties.
     w!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_width_properties._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_window_no_overflow
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%15 Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((carry! Int) (bit_buf! Int) (window_mask! Int) (w! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow.
     carry! bit_buf! window_mask! w!
    ) (and
     (=>
      %%global_location_label%%15
      (<= carry! 1)
     )
     (=>
      %%global_location_label%%16
      (and
       (>= w! 2)
       (<= w! 8)
     ))
     (=>
      %%global_location_label%%17
      (= window_mask! (Sub (uClip 64 (bitshl (I 1) (I (uClip 64 w!)))) 1))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow.
     carry! bit_buf! window_mask! w!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow.
 (Int Int Int Int) Bool
)
(assert
 (forall ((carry! Int) (bit_buf! Int) (window_mask! Int) (w! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow.
     carry! bit_buf! window_mask! w!
    ) (and
     (<= (uClip 64 (bitand (I bit_buf!) (I window_mask!))) window_mask!)
     (<= (Add carry! (uClip 64 (bitand (I bit_buf!) (I window_mask!)))) (uClip 64 (bitshl
        (I 1) (I (uClip 64 w!))
     )))
     (< (Add carry! (uClip 64 (bitand (I bit_buf!) (I window_mask!)))) 18446744073709551615)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow.
     carry! bit_buf! window_mask! w!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_window_no_overflow._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_reconstruct_split
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split.
 (vstd!seq.Seq<i8.>. Int) Bool
)
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split.
     naf! k!
    ) (=>
     %%global_location_label%%18
     (<= k! (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split.
     naf! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split.
 (vstd!seq.Seq<i8.>. Int) Bool
)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split.
     naf! k!
    ) (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (Poly%vstd!seq.Seq<i8.>. naf!))
     (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (
         SINT 8
        ) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I k!)
       )
      ) (Mul (vstd!arithmetic.power2.pow2.? (I k!)) (curve25519_dalek!specs.scalar_specs.reconstruct.?
        (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I k!) (I (vstd!seq.Seq.len.?
           $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!)
   ))))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split.
     naf! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_reconstruct_zero_extend
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
 (vstd!seq.Seq<i8.>. Int Int) Bool
)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (k! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
     naf! k! n!
    ) (and
     (=>
      %%global_location_label%%19
      (<= k! n!)
     )
     (=>
      %%global_location_label%%20
      (<= n! (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!)))
     )
     (=>
      %%global_location_label%%21
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= k! tmp%%$)
            (< tmp%%$ n!)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) j$)) 0)
        ))
        :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) j$))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_reconstruct_zero_extend_30
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_reconstruct_zero_extend_30
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
     naf! k! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
 (vstd!seq.Seq<i8.>. Int Int) Bool
)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (k! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
     naf! k! n!
    ) (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (
        SINT 8
       ) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I n!)
      )
     ) (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (SINT
        8
       ) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I k!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
     naf! k! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_even_step
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step.
 (vstd!seq.Seq<i8.>. Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (pos! Int) (carry! Int) (scalar_val! Int) (w! Int)
   (extracted! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step. naf!
     pos! carry! scalar_val! w! extracted!
    ) (and
     (=>
      %%global_location_label%%22
      (< pos! 256)
     )
     (=>
      %%global_location_label%%23
      (= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!)) 256)
     )
     (=>
      %%global_location_label%%24
      (<= carry! 1)
     )
     (=>
      %%global_location_label%%25
      (>= w! 2)
     )
     (=>
      %%global_location_label%%26
      (= (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $
          (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I pos!)
         )
        ) (Mul carry! (vstd!arithmetic.power2.pow2.? (I pos!)))
       ) (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!)))
     ))
     (=>
      %%global_location_label%%27
      (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I pos!)))
       0
     ))
     (=>
      %%global_location_label%%28
      (= extracted! (EucMod (EucDiv scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!)))
        (vstd!arithmetic.power2.pow2.? (I w!))
     )))
     (=>
      %%global_location_label%%29
      (= (EucMod (nClip (Add carry! extracted!)) 2) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step.
     naf! pos! carry! scalar_val! w! extracted!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step.
 (vstd!seq.Seq<i8.>. Int Int Int Int Int) Bool
)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (pos! Int) (carry! Int) (scalar_val! Int) (w! Int)
   (extracted! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step. naf!
     pos! carry! scalar_val! w! extracted!
    ) (= (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.?
        $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I (nClip (Add pos! 1)))
       )
      ) (Mul carry! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! 1)))))
     ) (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! 1)))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step.
     naf! pos! carry! scalar_val! w! extracted!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_even_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_high_bits_zero
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero.
 (Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((scalar_val! Int) (pos! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero.
     scalar_val! pos!
    ) (and
     (=>
      %%global_location_label%%30
      (< scalar_val! (vstd!arithmetic.power2.pow2.? (I 255)))
     )
     (=>
      %%global_location_label%%31
      (>= pos! 255)
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero.
     scalar_val! pos!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero.
 (Int Int) Bool
)
(assert
 (forall ((scalar_val! Int) (pos! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero.
     scalar_val! pos!
    ) (= (EucDiv scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!))) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero.
     scalar_val! pos!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_high_bits_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_wrapping_sub_correct
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((window! Int) (width! Int) (w! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct.
     window! width! w!
    ) (and
     (=>
      %%global_location_label%%32
      (let
       ((tmp%%$ w!))
       (and
        (<= 2 tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%33
      (= width! (uClip 64 (bitshl (I 1) (I (uClip 64 w!)))))
     )
     (=>
      %%global_location_label%%34
      (>= window! (EucDiv width! 2))
     )
     (=>
      %%global_location_label%%35
      (<= window! width!)
     )
     (=>
      %%global_location_label%%36
      (= (EucMod window! 2) 1)
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct.
     window! width! w!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct.
 (Int Int Int) Bool
)
(assert
 (forall ((window! Int) (width! Int) (w! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct.
     window! width! w!
    ) (let
     ((result$ (vstd!std_specs.num.i8_specs.wrapping_sub%returns_clause_autospec.? (I (iClip
          8 window!
         )
        ) (I (iClip 8 width!))
     )))
     (= result$ (Sub window! width!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct.
     window! width! w!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_wrapping_sub_correct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_digit_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((window! Int) (w! Int) (width! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds. window!
     w! width!
    ) (and
     (=>
      %%global_location_label%%37
      (let
       ((tmp%%$ w!))
       (and
        (<= 2 tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%38
      (= width! (uClip 64 (bitshl (I 1) (I (uClip 64 w!)))))
     )
     (=>
      %%global_location_label%%39
      (>= window! 1)
     )
     (=>
      %%global_location_label%%40
      (<= window! width!)
     )
     (=>
      %%global_location_label%%41
      (= (EucMod window! 2) 1)
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds.
     window! w! width!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds.
 (Int Int Int) Bool
)
(assert
 (forall ((window! Int) (w! Int) (width! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds. window!
     w! width!
    ) (and
     (=>
      (< window! (EucDiv width! 2))
      (>= window! 1)
     )
     (=>
      (< window! (EucDiv width! 2))
      (< window! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub w! 1)))))
     )
     (=>
      (>= window! (EucDiv width! 2))
      (> (Sub window! width!) (Sub 0 (vstd!arithmetic.power2.pow2.? (I (nClip (Sub w! 1))))))
     )
     (=>
      (>= window! (EucDiv width! 2))
      (< (Sub window! width!) 0)
     )
     (=>
      (< window! (EucDiv width! 2))
      (not (= (EucMod window! 2) 0))
     )
     (=>
      (>= window! (EucDiv width! 2))
      (not (= (EucMod (Sub window! width!) 2) 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds.
     window! w! width!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_digit_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_odd_step
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step.
 (vstd!seq.Seq<i8.>. Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (pos! Int) (w! Int) (scalar_val! Int) (old_carry!
    Int
   ) (new_carry! Int) (extracted! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step. naf!
     pos! w! scalar_val! old_carry! new_carry! extracted!
    ) (and
     (=>
      %%global_location_label%%42
      (let
       ((tmp%%$ w!))
       (and
        (<= 2 tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%43
      (< pos! 256)
     )
     (=>
      %%global_location_label%%44
      (<= (nClip (Add pos! w!)) (nClip (Add 256 w!)))
     )
     (=>
      %%global_location_label%%45
      (= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!)) 256)
     )
     (=>
      %%global_location_label%%46
      (<= old_carry! 1)
     )
     (=>
      %%global_location_label%%47
      (<= new_carry! 1)
     )
     (=>
      %%global_location_label%%48
      (= (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $
          (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I pos!)
         )
        ) (Mul old_carry! (vstd!arithmetic.power2.pow2.? (I pos!)))
       ) (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!)))
     ))
     (=>
      %%global_location_label%%49
      (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I pos!)))
       (Sub (Add old_carry! extracted!) (Mul new_carry! (vstd!arithmetic.power2.pow2.? (I w!))))
     ))
     (=>
      %%global_location_label%%50
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (and
           (let
            ((tmp%%$ (%I j$)))
            (and
             (< pos! tmp%%$)
             (< tmp%%$ (nClip (Add pos! w!)))
           ))
           (< (%I j$) 256)
          )
          (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) j$)) 0)
        ))
        :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) j$))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_58
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_58
     )))
     (=>
      %%global_location_label%%51
      (= extracted! (EucMod (EucDiv scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!)))
        (vstd!arithmetic.power2.pow2.? (I w!))
     )))
     (=>
      %%global_location_label%%52
      (< extracted! (vstd!arithmetic.power2.pow2.? (I w!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step.
     naf! pos! w! scalar_val! old_carry! new_carry! extracted!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step.
 (vstd!seq.Seq<i8.>. Int Int Int Int Int Int) Bool
)
(assert
 (forall ((naf! vstd!seq.Seq<i8.>.) (pos! Int) (w! Int) (scalar_val! Int) (old_carry!
    Int
   ) (new_carry! Int) (extracted! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step. naf!
     pos! w! scalar_val! old_carry! new_carry! extracted!
    ) (let
     ((end_pos$ (ite
        (<= (nClip (Add pos! w!)) 256)
        (nClip (Add pos! w!))
        256
     )))
     (= (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $
         (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I end_pos$)
        )
       ) (Mul new_carry! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))))
      ) (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step.
     naf! pos! w! scalar_val! old_carry! new_carry! extracted!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_naf_odd_step._definition
)))

;; Function-Def curve25519_dalek::lemmas::scalar_lemmas_::naf_lemmas::lemma_naf_odd_step
;; curve25519-dalek/src/lemmas/scalar_lemmas_/naf_lemmas.rs:266:1: 274:2 (#0)
(get-info :all-statistics)
(push)
 (declare-const naf! vstd!seq.Seq<i8.>.)
 (declare-const pos! Int)
 (declare-const w! Int)
 (declare-const scalar_val! Int)
 (declare-const old_carry! Int)
 (declare-const new_carry! Int)
 (declare-const extracted! Int)
 (declare-const tmp%1 Bool)
 (declare-const j@ Poly)
 (declare-const tmp%2 Bool)
 (declare-const idx@ Int)
 (declare-const tmp%3 Bool)
 (declare-const tmp%4 Bool)
 (declare-const tmp%5 Bool)
 (declare-const s1@ vstd!seq.Seq<i8.>.)
 (declare-const tmp%6 vstd!seq.Seq<i8.>.)
 (declare-const tmp%7 Bool)
 (declare-const tmp%8 Int)
 (declare-const tmp%9 Bool)
 (declare-const tmp%10 Int)
 (declare-const pw@ Int)
 (declare-const p_pos@ Int)
 (declare-const nc@ Int)
 (declare-const digit_val@ Int)
 (declare-const coef_int@ Int)
 (declare-const recon_old@ Int)
 (declare-const end_pos@ Int)
 (declare-const suffix@ vstd!seq.Seq<i8.>.)
 (declare-const suffix_len@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 pos!)
 )
 (assert
  (<= 0 w!)
 )
 (assert
  (<= 0 scalar_val!)
 )
 (assert
  (<= 0 old_carry!)
 )
 (assert
  (<= 0 new_carry!)
 )
 (assert
  (<= 0 extracted!)
 )
 (assert
  (let
   ((tmp%%$ w!))
   (and
    (<= 2 tmp%%$)
    (<= tmp%%$ 8)
 )))
 (assert
  (< pos! 256)
 )
 (assert
  (<= (nClip (Add pos! w!)) (nClip (Add 256 w!)))
 )
 (assert
  (= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!)) 256)
 )
 (assert
  (<= old_carry! 1)
 )
 (assert
  (<= new_carry! 1)
 )
 (assert
  (= (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $
      (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I pos!)
     )
    ) (Mul old_carry! (vstd!arithmetic.power2.pow2.? (I pos!)))
   ) (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!)))
 ))
 (assert
  (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I pos!)))
   (Sub (Add old_carry! extracted!) (Mul new_carry! (vstd!arithmetic.power2.pow2.? (I w!))))
 ))
 (assert
  (forall ((j$ Poly)) (!
    (=>
     (has_type j$ INT)
     (=>
      (and
       (let
        ((tmp%%$ (%I j$)))
        (and
         (< pos! tmp%%$)
         (< tmp%%$ (nClip (Add pos! w!)))
       ))
       (< (%I j$) 256)
      )
      (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) j$)) 0)
    ))
    :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) j$))
    :qid user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_71
    :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_71
 )))
 (assert
  (= extracted! (EucMod (EucDiv scalar_val! (vstd!arithmetic.power2.pow2.? (I pos!)))
    (vstd!arithmetic.power2.pow2.? (I w!))
 )))
 (assert
  (< extracted! (vstd!arithmetic.power2.pow2.? (I w!)))
 )
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%4 Bool)
 ;; assertion failed
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; assertion failed
 (declare-const %%location_label%%7 Bool)
 ;; assertion failed
 (declare-const %%location_label%%8 Bool)
 ;; assertion failed
 (declare-const %%location_label%%9 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%10 Bool)
 ;; assertion failed
 (declare-const %%location_label%%11 Bool)
 ;; assertion failed
 (declare-const %%location_label%%12 Bool)
 ;; assertion failed
 (declare-const %%location_label%%13 Bool)
 ;; assertion failed
 (declare-const %%location_label%%14 Bool)
 ;; assertion failed
 (declare-const %%location_label%%15 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%16 Bool)
 ;; assertion failed
 (declare-const %%location_label%%17 Bool)
 ;; assertion failed
 (declare-const %%location_label%%18 Bool)
 ;; assertion failed
 (declare-const %%location_label%%19 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%20 Bool)
 (assert
  (not (=>
    (= pw@ (vstd!arithmetic.power2.pow2.? (I w!)))
    (=>
     (= p_pos@ (vstd!arithmetic.power2.pow2.? (I pos!)))
     (=>
      (= nc@ new_carry!)
      (=>
       (= digit_val@ (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I
           pos!
       ))))
       (=>
        (= coef_int@ (Add old_carry! extracted!))
        (=>
         (= recon_old@ (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.?
            $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I pos!)
         )))
         (=>
          (= end_pos@ (ite
            (<= (nClip (Add pos! w!)) 256)
            (nClip (Add pos! w!))
            256
          ))
          (=>
           (= suffix@ (%Poly%vstd!seq.Seq<i8.>. (vstd!seq.Seq.subrange.? $ (SINT 8) (vstd!seq.Seq.subrange.?
               $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I end_pos@)
              ) (I pos!) (I (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>.
                  naf!
                 ) (I 0) (I end_pos@)
           ))))))
           (=>
            (= suffix_len@ (nClip (Sub end_pos@ pos!)))
            (and
             (=>
              (= tmp%1 (= (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) (I 0))
                (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I pos!))
              ))
              (and
               (=>
                %%location_label%%0
                tmp%1
               )
               (=>
                tmp%1
                (and
                 (and
                  (=>
                   (has_type j@ INT)
                   (=>
                    (let
                     ((tmp%%$ (%I j@)))
                     (and
                      (<= 1 tmp%%$)
                      (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@)))
                    ))
                    (=>
                     (= idx@ (Add pos! (%I j@)))
                     (=>
                      (= tmp%2 (= (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j@)
                        (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I idx@))
                      ))
                      (and
                       (=>
                        %%location_label%%1
                        tmp%2
                       )
                       (=>
                        tmp%2
                        (=>
                         %%location_label%%2
                         (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j@)) 0)
                  )))))))
                  (=>
                   (forall ((j$ Poly)) (!
                     (=>
                      (has_type j$ INT)
                      (=>
                       (let
                        ((tmp%%$ (%I j$)))
                        (and
                         (<= 1 tmp%%$)
                         (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@)))
                       ))
                       (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j$)) 0)
                     ))
                     :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j$))
                     :qid user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_59
                     :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_59
                   ))
                   (=>
                    %%location_label%%3
                    (forall ((j$ Poly)) (!
                      (=>
                       (has_type j$ INT)
                       (=>
                        (let
                         ((tmp%%$ (%I j$)))
                         (and
                          (<= 1 tmp%%$)
                          (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@)))
                        ))
                        (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j$)) 0)
                      ))
                      :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j$))
                      :qid user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_60
                      :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_60
                 )))))
                 (=>
                  (forall ((j$ Poly)) (!
                    (=>
                     (has_type j$ INT)
                     (=>
                      (let
                       ((tmp%%$ (%I j$)))
                       (and
                        (<= 1 tmp%%$)
                        (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@)))
                      ))
                      (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j$)) 0)
                    ))
                    :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. suffix@) j$))
                    :qid user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_61
                    :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___naf_lemmas__lemma_naf_odd_step_61
                  ))
                  (and
                   (=>
                    %%location_label%%4
                    (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
                     suffix@ 1 suffix_len@
                   ))
                   (=>
                    (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_zero_extend.
                     suffix@ 1 suffix_len@
                    )
                    (=>
                     (= tmp%3 (ext_eq false (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.subrange.? $ (SINT
                         8
                        ) (Poly%vstd!seq.Seq<i8.>. suffix@) (I 0) (I suffix_len@)
                       ) (Poly%vstd!seq.Seq<i8.>. suffix@)
                     ))
                     (and
                      (=>
                       %%location_label%%5
                       tmp%3
                      )
                      (=>
                       tmp%3
                       (and
                        (=>
                         (= s1@ (%Poly%vstd!seq.Seq<i8.>. (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>.
                             suffix@
                            ) (I 0) (I 1)
                         )))
                         (=>
                          (= tmp%4 (= (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>.
                               s1@
                              ) (I 1) (I (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. s1@)))
                             )
                            ) 0
                          ))
                          (and
                           (=>
                            %%location_label%%6
                            tmp%4
                           )
                           (=>
                            tmp%4
                            (=>
                             (= tmp%5 (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.?
                                 $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. s1@) (I 1) (I (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>.
                                    s1@
                                ))))
                               ) 0
                             ))
                             (and
                              (=>
                               %%location_label%%7
                               tmp%5
                              )
                              (=>
                               tmp%5
                               (=>
                                %%location_label%%8
                                (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (SINT
                                    8
                                   ) (Poly%vstd!seq.Seq<i8.>. suffix@) (I 0) (I 1)
                                  )
                                 ) digit_val@
                        )))))))))
                        (=>
                         (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (SINT
                             8
                            ) (Poly%vstd!seq.Seq<i8.>. suffix@) (I 0) (I 1)
                           )
                          ) digit_val@
                         )
                         (=>
                          %%location_label%%9
                          (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (Poly%vstd!seq.Seq<i8.>. suffix@))
                           digit_val@
             ))))))))))))))
             (=>
              (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (Poly%vstd!seq.Seq<i8.>. suffix@))
               digit_val@
              )
              (and
               (=>
                (= tmp%6 (%Poly%vstd!seq.Seq<i8.>. (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>.
                    naf!
                   ) (I 0) (I end_pos@)
                )))
                (and
                 (=>
                  %%location_label%%10
                  (req%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split. tmp%6
                   pos!
                 ))
                 (=>
                  (ens%curve25519_dalek!lemmas.scalar_lemmas_.naf_lemmas.lemma_reconstruct_split. tmp%6
                   pos!
                  )
                  (=>
                   (= tmp%7 (ext_eq false (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.subrange.? $ (SINT
                       8
                      ) (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I end_pos@))
                      (I 0) (I pos!)
                     ) (vstd!seq.Seq.subrange.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I pos!))
                   ))
                   (and
                    (=>
                     %%location_label%%11
                     tmp%7
                    )
                    (=>
                     tmp%7
                     (=>
                      (= tmp%8 (curve25519_dalek!specs.scalar_specs.reconstruct.? (Poly%vstd!seq.Seq<i8.>.
                         suffix@
                      )))
                      (=>
                       (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. p_pos@ tmp%8)
                       (=>
                        %%location_label%%12
                        (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (SINT
                            8
                           ) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I end_pos@)
                          )
                         ) (Add recon_old@ (Mul p_pos@ digit_val@))
               ))))))))))
               (=>
                (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $ (SINT
                    8
                   ) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I end_pos@)
                  )
                 ) (Add recon_old@ (Mul p_pos@ digit_val@))
                )
                (and
                 (=>
                  (ens%vstd!arithmetic.power2.lemma_pow2_adds. w! pos!)
                  (=>
                   (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. pw@ p_pos@)
                   (=>
                    %%location_label%%13
                    (= (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))) (Mul pw@ p_pos@))
                 )))
                 (=>
                  (= (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))) (Mul pw@ p_pos@))
                  (and
                   (=>
                    (= tmp%9 (= digit_val@ (Sub coef_int@ (Mul nc@ pw@))))
                    (and
                     (=>
                      %%location_label%%14
                      tmp%9
                     )
                     (=>
                      tmp%9
                      (=>
                       (= tmp%10 (Mul nc@ pw@))
                       (=>
                        (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. p_pos@ coef_int@
                         tmp%10
                        )
                        (=>
                         (ens%vstd!arithmetic.mul.lemma_mul_is_associative. nc@ pw@ p_pos@)
                         (=>
                          %%location_label%%15
                          (= (Add (Mul digit_val@ p_pos@) (Mul nc@ (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos!
                                 w!
                            )))))
                           ) (Mul coef_int@ p_pos@)
                   ))))))))
                   (=>
                    (= (Add (Mul digit_val@ p_pos@) (Mul nc@ (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos!
                           w!
                      )))))
                     ) (Mul coef_int@ p_pos@)
                    )
                    (and
                     (=>
                      (ens%vstd!arithmetic.power2.lemma_pow2_pos. pos!)
                      (=>
                       (ens%vstd!arithmetic.power2.lemma_pow2_pos. w!)
                       (and
                        (=>
                         %%location_label%%16
                         (req%vstd!arithmetic.div_mod.lemma_mod_breakdown. scalar_val! p_pos@ pw@)
                        )
                        (=>
                         (ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. scalar_val! p_pos@ pw@)
                         (=>
                          (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. p_pos@ extracted!)
                          (=>
                           %%location_label%%17
                           (= (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))))
                            (Add (Mul extracted! p_pos@) (EucMod scalar_val! p_pos@))
                     )))))))
                     (=>
                      (= (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))))
                       (Add (Mul extracted! p_pos@) (EucMod scalar_val! p_pos@))
                      )
                      (and
                       (=>
                        (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. p_pos@ old_carry!
                         extracted!
                        )
                        (=>
                         %%location_label%%18
                         (= (Mul coef_int@ p_pos@) (Add (Mul old_carry! p_pos@) (Mul extracted! p_pos@)))
                       ))
                       (=>
                        (= (Mul coef_int@ p_pos@) (Add (Mul old_carry! p_pos@) (Mul extracted! p_pos@)))
                        (and
                         (=>
                          (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. digit_val@ p_pos@)
                          (=>
                           %%location_label%%19
                           (= (Mul digit_val@ p_pos@) (Mul p_pos@ digit_val@))
                         ))
                         (=>
                          (= (Mul digit_val@ p_pos@) (Mul p_pos@ digit_val@))
                          (=>
                           %%location_label%%20
                           (let
                            ((end_pos$ (ite
                               (<= (nClip (Add pos! w!)) 256)
                               (nClip (Add pos! w!))
                               256
                            )))
                            (= (Add (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.subrange.? $
                                (SINT 8) (Poly%vstd!seq.Seq<i8.>. naf!) (I 0) (I end_pos$)
                               )
                              ) (Mul new_carry! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))))
                             ) (EucMod scalar_val! (vstd!arithmetic.power2.pow2.? (I (nClip (Add pos! w!)))))
 ))))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
