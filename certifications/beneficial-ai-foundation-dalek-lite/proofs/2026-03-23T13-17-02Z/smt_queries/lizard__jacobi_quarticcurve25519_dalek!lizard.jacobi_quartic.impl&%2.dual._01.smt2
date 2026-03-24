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

;; MODULE 'module lizard::jacobi_quartic'
;; curve25519-dalek/src/lizard/jacobi_quartic.rs:334:5: 334:54 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%55.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%55.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%56.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%56.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%59.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%59.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%64.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%64.mul_spec. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!pervasive.strictly_cloned. FuelId)
(declare-const fuel%vstd!pervasive.cloned. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%42.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1. FuelId)
(declare-const fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID. FuelId)
(declare-const fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_negative. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_abs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.nat_invsqrt. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sqrt_m1. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.sqrt_id. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. FuelId)
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
 (distinct fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%31.add_req.
  fuel%vstd!std_specs.ops.impl&%31.add_spec. fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%32.add_req. fuel%vstd!std_specs.ops.impl&%32.add_spec.
  fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%35.add_req.
  fuel%vstd!std_specs.ops.impl&%35.add_spec. fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%40.add_req. fuel%vstd!std_specs.ops.impl&%40.add_spec.
  fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%43.sub_req.
  fuel%vstd!std_specs.ops.impl&%43.sub_spec. fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%44.sub_req. fuel%vstd!std_specs.ops.impl&%44.sub_spec.
  fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%47.sub_req.
  fuel%vstd!std_specs.ops.impl&%47.sub_spec. fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%52.sub_req. fuel%vstd!std_specs.ops.impl&%52.sub_spec.
  fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec. fuel%vstd!std_specs.ops.impl&%55.mul_req.
  fuel%vstd!std_specs.ops.impl&%55.mul_spec. fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec.
  fuel%vstd!std_specs.ops.impl&%56.mul_req. fuel%vstd!std_specs.ops.impl&%56.mul_spec.
  fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec. fuel%vstd!std_specs.ops.impl&%59.mul_req.
  fuel%vstd!std_specs.ops.impl&%59.mul_spec. fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec.
  fuel%vstd!std_specs.ops.impl&%64.mul_req. fuel%vstd!std_specs.ops.impl&%64.mul_spec.
  fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_array_ext_equal.
  fuel%vstd!array.axiom_array_has_resolved. fuel%vstd!pervasive.strictly_cloned. fuel%vstd!pervasive.cloned.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%42.view.
  fuel%vstd!view.impl&%44.view. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req. fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO. fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.
  fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1. fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID.
  fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1. fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs. fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.
  fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio. fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.
  fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio. fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.
  fuel%curve25519_dalek!specs.field_specs.is_negative. fuel%curve25519_dalek!specs.field_specs.field_abs.
  fuel%curve25519_dalek!specs.field_specs.nat_invsqrt. fuel%curve25519_dalek!specs.field_specs.sqrt_m1.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.mask51.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.
  fuel%curve25519_dalek!specs.lizard_specs.sqrt_id. fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1.
  fuel%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. fuel%vstd!array.group_array_axioms.
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
  (fuel_bool_default fuel%vstd!array.group_array_axioms.)
  (and
   (fuel_bool_default fuel%vstd!array.array_len_matches_n.)
   (fuel_bool_default fuel%vstd!array.lemma_array_index.)
   (fuel_bool_default fuel%vstd!array.axiom_array_ext_equal.)
   (fuel_bool_default fuel%vstd!array.axiom_array_has_resolved.)
)))
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
  (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
  (and
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq.)
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
  (and
   (fuel_bool_default fuel%vstd!slice.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_ext_equal.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_has_resolved.)
)))
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

;; Trait-Decls
(declare-fun tr_bound%vstd!array.ArrayAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)
(declare-fun tr_bound%core!clone.Clone. (Dcr Type) Bool)
(declare-fun tr_bound%core!alloc.Allocator. (Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Add. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.AddSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Sub. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.SubSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Mul. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.MulSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%subtle!ConstantTimeEq. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Add./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Add./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Sub./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Sub./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Mul./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Mul./Output (Dcr Type Dcr Type) Type)

;; Datatypes
(declare-fun pointee_metadata% (Dcr) Type)
(declare-fun pointee_metadata%% (Dcr) Dcr)
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata% d) TYPE%tuple%0.)
   )
   :pattern ((pointee_metadata% d))
   :qid prelude_project_pointee_metadata_sized
   :skolemid skolem_prelude_project_pointee_metadata_sized
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata%% d) $)
   )
   :pattern ((pointee_metadata%% d))
   :qid prelude_project_pointee_metadata_decoration_sized
   :skolemid skolem_prelude_project_pointee_metadata_decoration_sized
)))
(assert
 (= (pointee_metadata% $slice) USIZE)
)
(assert
 (= (pointee_metadata%% $slice) $)
)
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata% (DST d)) (pointee_metadata% d))
   :pattern ((pointee_metadata% (DST d)))
   :qid prelude_project_pointee_metadata_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata%% (DST d)) (pointee_metadata%% d))
   :pattern ((pointee_metadata%% (DST d)))
   :qid prelude_project_pointee_metadata_decoration_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decoration_decorate_struct_inherit
)))
(declare-sort subtle!Choice. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. 0) (tuple%0. 0) (tuple%1. 0)
  (tuple%2. 0)
 ) (((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/?S
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/?T curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
  ) ((tuple%0./tuple%0)) ((tuple%1./tuple%1 (tuple%1./tuple%1/?0 Poly))) ((tuple%2./tuple%2
    (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1 Poly)
))))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun tuple%1./tuple%1/0 (tuple%1.) Poly)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%subtle!Choice. Type)
(declare-const TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. Type)
(declare-fun TYPE%tuple%1. (Dcr Type) Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun FNDEF%core!clone.Clone.clone. (Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%subtle!Choice. (subtle!Choice.) Poly)
(declare-fun %Poly%subtle!Choice. (Poly) subtle!Choice.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (Poly) curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%1. (tuple%1.) Poly)
(declare-fun %Poly%tuple%1. (Poly) tuple%1.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%array%. (Poly%array%. x)))
   :pattern ((Poly%array%. x))
   :qid internal_crate__array___box_axiom_definition
   :skolemid skolem_internal_crate__array___box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (x Poly)) (!
   (=>
    (has_type x (ARRAY T&. T& N&. N&))
    (= x (Poly%array%. (%Poly%array%. x)))
   )
   :pattern ((has_type x (ARRAY T&. T& N&. N&)))
   :qid internal_crate__array___unbox_axiom_definition
   :skolemid skolem_internal_crate__array___unbox_axiom_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (= x (%Poly%subtle!Choice. (Poly%subtle!Choice. x)))
   :pattern ((Poly%subtle!Choice. x))
   :qid internal_subtle__Choice_box_axiom_definition
   :skolemid skolem_internal_subtle__Choice_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%subtle!Choice.)
    (= x (Poly%subtle!Choice. (%Poly%subtle!Choice. x)))
   )
   :pattern ((has_type x TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_unbox_axiom_definition
   :skolemid skolem_internal_subtle__Choice_unbox_axiom_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.)
   :pattern ((has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_has_type_always_definition
   :skolemid skolem_internal_subtle__Choice_has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (= x (%Poly%vstd!raw_ptr.Provenance. (Poly%vstd!raw_ptr.Provenance. x)))
   :pattern ((Poly%vstd!raw_ptr.Provenance. x))
   :qid internal_vstd__raw_ptr__Provenance_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%vstd!raw_ptr.Provenance.)
    (= x (Poly%vstd!raw_ptr.Provenance. (%Poly%vstd!raw_ptr.Provenance. x)))
   )
   :pattern ((has_type x TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.)
   :pattern ((has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_has_type_always_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u8.>. (Poly%vstd!seq.Seq<u8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u8.>. x))
   :qid internal_vstd__seq__Seq<u8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (= x (Poly%vstd!seq.Seq<u8.>. (%Poly%vstd!seq.Seq<u8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_has_type_always_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (= x (%Poly%allocator_global%. (Poly%allocator_global%. x)))
   :pattern ((Poly%allocator_global%. x))
   :qid internal_crate__allocator_global___box_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ALLOCATOR_GLOBAL)
    (= x (Poly%allocator_global%. (%Poly%allocator_global%. x)))
   )
   :pattern ((has_type x ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___unbox_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___unbox_axiom_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL)
   :pattern ((has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___has_type_always_definition
   :skolemid skolem_internal_crate__allocator_global___has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= x (%Poly%vstd!raw_ptr.PtrData. (Poly%vstd!raw_ptr.PtrData. x)))
   :pattern ((Poly%vstd!raw_ptr.PtrData. x))
   :qid internal_vstd__raw_ptr__PtrData_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (= x (Poly%vstd!raw_ptr.PtrData. (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&)))
   :qid internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_addr! Int) (_provenance! vstd!raw_ptr.Provenance.) (
    _metadata! Poly
   )
  ) (!
   (=>
    (and
     (uInv SZ _addr!)
     (has_type _metadata! (pointee_metadata% T&.))
    )
    (has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr! _provenance!
       _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr!
       _provenance! _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/addr x) (vstd!raw_ptr.PtrData./PtrData/?addr x))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (uInv SZ (vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)) (has_type
     x (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/provenance x) (vstd!raw_ptr.PtrData./PtrData/?provenance
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/provenance x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/metadata x) (vstd!raw_ptr.PtrData./PtrData/?metadata
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
     (pointee_metadata% T&.)
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   )
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (= x (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
)))
(assert
 (forall ((_limbs! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 _limbs!)
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
    ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)) (!
   (= x (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. x))
   :qid internal_curve25519_dalek__lizard__jacobi_quartic__JacobiPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lizard__jacobi_quartic__JacobiPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
    (= x (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.))
   :qid internal_curve25519_dalek__lizard__jacobi_quartic__JacobiPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lizard__jacobi_quartic__JacobiPoint_unbox_axiom_definition
)))
(assert
 (forall ((_S! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _S!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint
       _S! _T!
      )
     ) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint
       _S! _T!
      )
     ) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
   ))
   :qid internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)) (!
   (= (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S x) (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/?S
     x
   ))
   :pattern ((curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S x))
   :qid internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S
       (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
   )
   :qid internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)) (!
   (= (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T x) (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/?T
     x
   ))
   :pattern ((curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T x))
   :qid internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T
       (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
   )
   :qid internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T_invariant_definition
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
(assert
 (forall ((x tuple%1.)) (!
   (= x (%Poly%tuple%1. (Poly%tuple%1. x)))
   :pattern ((Poly%tuple%1. x))
   :qid internal_crate__tuple__1_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (= x (Poly%tuple%1. (%Poly%tuple%1. x)))
   )
   :pattern ((has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_crate__tuple__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T%0&)
    (has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&))
   )
   :pattern ((has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1_constructor_definition
   :skolemid skolem_internal_tuple__1./tuple__1_constructor_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (= (tuple%1./tuple%1/0 x) (tuple%1./tuple%1/?0 x))
   :pattern ((tuple%1./tuple%1/0 x))
   :qid internal_tuple__1./tuple__1/0_accessor_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (has_type (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) T%0&)
   )
   :pattern ((tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1/0_invariant_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_invariant_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (=>
    (is-tuple%1./tuple%1 x)
    (height_lt (height (tuple%1./tuple%1/0 x)) (height (Poly%tuple%1. x)))
   )
   :pattern ((height (tuple%1./tuple%1/0 x)))
   :qid prelude_datatype_height_tuple%1./tuple%1/0
   :skolemid skolem_prelude_datatype_height_tuple%1./tuple%1/0
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%tuple%1. T%0&. T%0&))
     (has_type y (TYPE%tuple%1. T%0&. T%0&))
     (ext_eq deep T%0& (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (tuple%1./tuple%1/0 (%Poly%tuple%1.
        y
    ))))
    (ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y))
   :qid internal_tuple__1./tuple__1_ext_equal_definition
   :skolemid skolem_internal_tuple__1./tuple__1_ext_equal_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))
(declare-fun array_new (Dcr Type Int %%Function%%) Poly)
(declare-fun array_index (Dcr Type Dcr Type %%Function%% Poly) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (= (array_new Tdcr T N Fn) (Poly%array%. Fn))
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_array_new
   :skolemid skolem_prelude_array_new
)))
(declare-fun %%apply%%1 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%1 Fn i) T)
      )
      :pattern ((has_type (%%apply%%1 Fn i) T))
      :qid prelude_has_type_array_elts
      :skolemid skolem_prelude_has_type_array_elts
    ))
    (has_type (array_new Tdcr T N Fn) (ARRAY Tdcr T $ (CONST_INT N)))
   )
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_has_type_array_new
   :skolemid skolem_prelude_has_type_array_new
)))
(assert
 (forall ((Tdcr Dcr) (T Type) (Ndcr Dcr) (N Type) (Fn %%Function%%) (i Poly)) (!
   (=>
    (and
     (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr N))
     (has_type i INT)
    )
    (has_type (array_index Tdcr T $ N Fn i) T)
   )
   :pattern ((array_index Tdcr T $ N Fn i) (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr
      N
   )))
   :qid prelude_has_type_array_index
   :skolemid skolem_prelude_has_type_array_index
)))
(assert
 (!
  (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%) (i Int)) (!
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%1 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%1 Fn i))
    :qid prelude_array_index_trigger
    :skolemid skolem_prelude_array_index_trigger
  ))
  :named
  prelude_axiom_array_index
))

;; Trait-Bounds
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!view.View. Self%&. Self%&)
    (sized (proj%%vstd!view.View./V Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!view.View. Self%&. Self%&))
   :qid internal_vstd__view__View_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__view__View_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!clone.Clone. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%core!clone.Clone. Self%&. Self%&))
   :qid internal_core__clone__Clone_trait_type_bounds_definition
   :skolemid skolem_internal_core__clone__Clone_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!alloc.Allocator. Self%&. Self%&))
   :qid internal_core__alloc__Allocator_trait_type_bounds_definition
   :skolemid skolem_internal_core__alloc__Allocator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Add_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Add_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Sub_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Sub_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.SubSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.SubSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__SubSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__SubSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Mul. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Mul./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Mul. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Mul_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Mul_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.MulSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Mul. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.MulSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__MulSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__MulSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%subtle!ConstantTimeEq. Self%&. Self%&))
   :qid internal_subtle__ConstantTimeEq_trait_type_bounds_definition
   :skolemid skolem_internal_subtle__ConstantTimeEq_trait_type_bounds_definition
)))

;; Associated-Type-Impls
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) $)
   :pattern ((proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $slice (SLICE T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $slice (SLICE T&. T&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (REF A&.) A&) (proj%%vstd!view.View./V A&. A&))
   :pattern ((proj%%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (REF A&.) A&) (proj%vstd!view.View./V A&. A&))
   :pattern ((proj%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $ TYPE%tuple%0.) $)
)
(assert
 (= (proj%vstd!view.View./V $ TYPE%tuple%0.) TYPE%tuple%0.)
)
(assert
 (= (proj%%vstd!view.View./V $ BOOL) $)
)
(assert
 (= (proj%vstd!view.View./V $ BOOL) BOOL)
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (DST (proj%%vstd!view.View./V
      A0&. A0&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (TYPE%tuple%1. (proj%%vstd!view.View./V
      A0&. A0&
     ) (proj%vstd!view.View./V A0&. A0&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (DST (proj%%vstd!view.View./V
      A1&. A1&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (TYPE%tuple%2.
     (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&) (proj%%vstd!view.View./V
      A1&. A1&
     ) (proj%vstd!view.View./V A1&. A1&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::slice::spec_slice_len
(declare-fun vstd!slice.spec_slice_len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::view::View::view
(declare-fun vstd!view.View.view.? (Dcr Type Poly) Poly)
(declare-fun vstd!view.View.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::array_view
(declare-fun vstd!array.array_view.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::pervasive::strictly_cloned
(declare-fun vstd!pervasive.strictly_cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::pervasive::cloned
(declare-fun vstd!pervasive.cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_req
(declare-fun vstd!std_specs.ops.AddSpec.add_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::obeys_add_spec
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_spec
(declare-fun vstd!std_specs.ops.AddSpec.add_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::sub_req
(declare-fun vstd!std_specs.ops.SubSpec.sub_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.sub_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::obeys_sub_spec
(declare-fun vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.obeys_sub_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::sub_spec
(declare-fun vstd!std_specs.ops.SubSpec.sub_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.sub_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::MulSpec::mul_req
(declare-fun vstd!std_specs.ops.MulSpec.mul_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.MulSpec.mul_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::MulSpec::obeys_mul_spec
(declare-fun vstd!std_specs.ops.MulSpec.obeys_mul_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.MulSpec.obeys_mul_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::MulSpec::mul_spec
(declare-fun vstd!std_specs.ops.MulSpec.mul_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.MulSpec.mul_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::arbitrary
(declare-fun vstd!pervasive.arbitrary.? (Dcr Type) Poly)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.field_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_mul
(declare-fun curve25519_dalek!specs.field_specs.field_mul.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::backend::serial::u64::subtle_assumes::choice_is_true
(declare-fun curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::field_neg
(declare-fun curve25519_dalek!specs.field_specs.field_neg.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_reduce
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs::field_square
(declare-fun curve25519_dalek!specs.field_specs.field_square.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_sub_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_sub_limbs.? (Poly Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::impl&%16::ZERO
(declare-fun curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::impl&%16::ONE
(declare-fun curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::SQRT_M1
(declare-fun curve25519_dalek!backend.serial.u64.constants.SQRT_M1.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lizard::u64_constants::SQRT_ID
(declare-fun curve25519_dalek!lizard.u64_constants.SQRT_ID.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lizard::u64_constants::DP1_OVER_DM1
(declare-fun curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::sqrt_m1
(declare-fun curve25519_dalek!specs.field_specs.sqrt_m1.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::is_negative
(declare-fun curve25519_dalek!specs.field_specs.is_negative.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::nat_invsqrt
(declare-fun curve25519_dalek!specs.field_specs.nat_invsqrt.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_abs
(declare-fun curve25519_dalek!specs.field_specs.field_abs.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::is_sqrt_ratio
(declare-fun curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (Poly Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_fe51_as_bytes
(declare-fun curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::specs::field_specs::is_sqrt_ratio_times_i
(declare-fun curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (Poly Poly
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_is_sqrt_ratio
(declare-fun curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_is_sqrt_ratio_times_i
(declare-fun curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.? (Poly
  Poly Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::sqrt_id
(declare-fun curve25519_dalek!specs.lizard_specs.sqrt_id.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::lizard_specs::dp1_over_dm1
(declare-fun curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_elligator_inv
(declare-fun curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (Poly Poly)
 tuple%2.
)

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

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        )
       ) (%I len!)
    )))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_1
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_1
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (%I len!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_2
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
          :qid user_vstd__seq__axiom_seq_ext_equal_3
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_3
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_4
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_4
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_5
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_5
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_6
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_6
))))

;; Function-Axioms vstd::slice::spec_slice_len
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
   (=>
    (has_type slice! (SLICE T&. T&))
    (uInv SZ (vstd!slice.spec_slice_len.? T&. T& slice!))
   )
   :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
   :qid internal_vstd!slice.spec_slice_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.spec_slice_len.?_pre_post_definition
)))

;; Function-Axioms vstd::view::View::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!view.View.view.? Self%&. Self%& self!) (proj%vstd!view.View./V Self%&.
      Self%&
   )))
   :pattern ((vstd!view.View.view.? Self%&. Self%& self!))
   :qid internal_vstd!view.View.view.?_pre_post_definition
   :skolemid skolem_internal_vstd!view.View.view.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $slice (SLICE T&. T&)))
   :qid internal_vstd__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
    (=>
     (has_type slice! (SLICE T&. T&))
     (=>
      (sized T&.)
      (= (vstd!slice.spec_slice_len.? T&. T& slice!) (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.?
         $slice (SLICE T&. T&) slice!
    )))))
    :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
    :qid user_vstd__slice__axiom_spec_len_7
    :skolemid skolem_user_vstd__slice__axiom_spec_len_7
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::slice::SliceAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::slice::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!slice.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!slice.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)
       i!
    )))
    :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&.
      T& self! i!
    ))
    :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&)
   )
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&))
   :qid internal_vstd__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_slice_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (SLICE T&. T&))
      (has_type a2! (SLICE T&. T&))
     )
     (=>
      (sized T&.)
      (= (ext_eq false (SLICE T&. T&) a1! a2!) (and
        (= (vstd!slice.spec_slice_len.? T&. T& a1!) (vstd!slice.spec_slice_len.? T&. T& a2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& a1!))
            ))
            (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a1!) i$)
             (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a2!) i$)
          )))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a1!
            ) i$
          ))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a2!
            ) i$
          ))
          :qid user_vstd__slice__axiom_slice_ext_equal_8
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_8
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_9
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_9
))))

;; Broadcast vstd::slice::axiom_slice_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type slice! (SLICE T&. T&))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& slice!))
       ))
       (=>
        (has_resolved $slice (SLICE T&. T&) slice!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE
            T&. T&
           ) slice!
          ) i!
    ))))))
    :pattern ((has_resolved $slice (SLICE T&. T&) slice!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) i!
    ))
    :qid user_vstd__slice__axiom_slice_has_resolved_10
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_10
))))

;; Function-Axioms vstd::array::array_view
(assert
 (fuel_bool_default fuel%vstd!array.array_view.)
)
(declare-fun %%lambda%%0 (Dcr Type Dcr Type %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Dcr) (%%hole%%3 Type) (%%hole%%4
    %%Function%%
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (array_index %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 i$)
   )
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
    (= (vstd!array.array_view.? T&. T& N&. N& a!) (vstd!seq.Seq.new.? T&. T& $ (TYPE%fun%1.
       $ INT T&. T&
      ) (I (const_int N&)) (Poly%fun%1. (mk_fun (%%lambda%%0 T&. T& N&. N& (%Poly%array%. a!))))
    ))
    :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
    :qid internal_vstd!array.array_view.?_definition
    :skolemid skolem_internal_vstd!array.array_view.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
   (=>
    (has_type a! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.array_view.? T&. T& N&. N& a!) (TYPE%vstd!seq.Seq. T&. T&))
   )
   :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
   :qid internal_vstd!array.array_view.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.array_view.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!array.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%0.view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) (vstd!array.array_view.? T&.
       T& N&. N& self!
    )))
    :pattern ((vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__array__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::array::array_len_matches_n
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_len_matches_n.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!))
       (const_int N&)
    )))
    :pattern ((vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
       ar!
    )))
    :qid user_vstd__array__array_len_matches_n_11
    :skolemid skolem_user_vstd__array__array_len_matches_n_11
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::array::ArrayAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!array.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (i! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!)
       i!
    )))
    :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&.
      T& self! i!
    ))
    :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&. T&)
   )
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&.
     T&
   ))
   :qid internal_vstd__array__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::array::lemma_array_index
(assert
 (=>
  (fuel_bool fuel%vstd!array.lemma_array_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type a! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized T&.)
        (uInv SZ (const_int N&))
       )
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
      )))
      (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!)
        i!
       ) (vstd!seq.Seq.index.? T&. T& (vstd!array.array_view.? T&. T& N&. N& a!) i!)
    )))
    :pattern ((array_index T&. T& N&. N& (%Poly%array%. a!) i!))
    :qid user_vstd__array__lemma_array_index_12
    :skolemid skolem_user_vstd__array__lemma_array_index_12
))))

;; Broadcast vstd::array::axiom_array_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (ARRAY T&. T& N&. N&))
      (has_type a2! (ARRAY T&. T& N&. N&))
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (ext_eq false (ARRAY T&. T& N&. N&) a1! a2!) (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a1!)
             i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a2!)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a1!
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a2!
           ) i$
         ))
         :qid user_vstd__array__axiom_array_ext_equal_13
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_13
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_14
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_14
))))

;; Broadcast vstd::array::axiom_array_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (array! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type array! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
       ))
       (=>
        (has_resolved $ (ARRAY T&. T& N&. N&) array!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&.
            T& N&. N&
           ) array!
          ) i!
    ))))))
    :pattern ((has_resolved $ (ARRAY T&. T& N&. N&) array!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) array!) i!
    ))
    :qid user_vstd__array__axiom_array_has_resolved_15
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_15
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq
(assert
 (forall ((T&. Dcr) (T& Type) (data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!) (PTR T&. T&))
   )
   :pattern ((vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. $ (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. $ (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (= (vstd!raw_ptr.view_reverse_for_eq.? T&. T& (vstd!view.View.view.? $ (PTR T&. T&)
        a!
       )
      ) a!
    ))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_16
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_16
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq_sized
(assert
 (forall ((T&. Dcr) (T& Type) (addr! Poly) (provenance! Poly)) (!
   (=>
    (and
     (has_type addr! USIZE)
     (has_type provenance! TYPE%vstd!raw_ptr.Provenance.)
    )
    (has_type (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!) (PTR
      T&. T&
   )))
   :pattern ((vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq_sized
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (=>
      (sized T&.)
      (= (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& (I (vstd!raw_ptr.PtrData./PtrData/addr
          (%Poly%vstd!raw_ptr.PtrData. (vstd!view.View.view.? $ (PTR T&. T&) a!))
         )
        ) (Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.PtrData./PtrData/provenance (%Poly%vstd!raw_ptr.PtrData.
           (vstd!view.View.view.? $ (PTR T&. T&) a!)
        )))
       ) a!
    )))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_17
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_17
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!alloc.Allocator. $ ALLOCATOR_GLOBAL)
)

;; Function-Specs core::clone::Clone::clone
(declare-fun ens%core!clone.Clone.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (%return! Poly)) (!
   (= (ens%core!clone.Clone.clone. Self%&. Self%& self! %return!) (has_type %return! Self%&))
   :pattern ((ens%core!clone.Clone.clone. Self%&. Self%& self! %return!))
   :qid internal_ens__core!clone.Clone.clone._definition
   :skolemid skolem_internal_ens__core!clone.Clone.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type)) (!
   (=>
    (has_type closure%$ (TYPE%tuple%1. (REF Self%&.) Self%&))
    (=>
     (let
      ((self$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      true
     )
     (closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.)) (TYPE%tuple%1.
       (REF Self%&.) Self%&
      ) (F fndef_singleton) closure%$
   )))
   :pattern ((closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.))
     (TYPE%tuple%1. (REF Self%&.) Self%&) (F fndef_singleton) closure%$
   ))
   :qid user_core__clone__Clone__clone_18
   :skolemid skolem_user_core__clone__Clone__clone_18
)))

;; Function-Specs core::clone::impls::impl&%6::clone
(declare-fun ens%core!clone.impls.impl&%6.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%6.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 8) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%6.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__6.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__6.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 8)))
     (has_type res$ (UINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 8)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 8)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%6__clone_19
   :skolemid skolem_user_core__clone__impls__impl&%6__clone_19
)))

;; Function-Specs core::clone::impls::impl&%14::clone
(declare-fun ens%core!clone.impls.impl&%14.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%14.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (SINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%14.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__14.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__14.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (SINT 32)))
     (has_type res$ (SINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (SINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (SINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%14__clone_20
   :skolemid skolem_user_core__clone__impls__impl&%14__clone_20
)))

;; Function-Specs core::clone::impls::impl&%9::clone
(declare-fun ens%core!clone.impls.impl&%9.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%9.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 64) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%9.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__9.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__9.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 64)))
     (has_type res$ (UINT 64))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 64)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 64)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%9__clone_21
   :skolemid skolem_user_core__clone__impls__impl&%9__clone_21
)))

;; Function-Specs core::clone::impls::impl&%5::clone
(declare-fun ens%core!clone.impls.impl&%5.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%5.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ USIZE x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%5.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) USIZE))
     (has_type res$ USIZE)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1. (
        REF $
       ) USIZE
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1.
      (REF $) USIZE
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%5__clone_22
   :skolemid skolem_user_core__clone__impls__impl&%5__clone_22
)))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%4 Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%4
      (< x! m!)
     )
     (=>
      %%global_location_label%%5
      (< 0 m!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (= (EucMod x! m!) x!))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))

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

;; Function-Specs core::clone::impls::impl&%21::clone
(declare-fun ens%core!clone.impls.impl&%21.clone. (Poly Poly) Bool)
(assert
 (forall ((b! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%21.clone. b! %return!) (and
     (ens%core!clone.Clone.clone. $ BOOL b! %return!)
     (= %return! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%21.clone. b! %return!))
   :qid internal_ens__core!clone.impls.impl&__21.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__21.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) BOOL))
     (has_type %return$ BOOL)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) BOOL
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((b$ (%B (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%B %return$) b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1.
      (REF $) BOOL
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%21__clone_23
   :skolemid skolem_user_core__clone__impls__impl&%21__clone_23
)))

;; Function-Specs core::clone::impls::impl&%3::clone
(declare-fun ens%core!clone.impls.impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (REF T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__core!clone.impls.impl&__3.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (REF T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.))) (TYPE%tuple%1.
       (REF (REF T&.)) T&
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.)))
     (TYPE%tuple%1. (REF (REF T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%3__clone_24
   :skolemid skolem_user_core__clone__impls__impl&%3__clone_24
)))

;; Function-Axioms vstd::pervasive::strictly_cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.strictly_cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.strictly_cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.strictly_cloned.? T&. T& a! b!) (closure_ens (FNDEF%core!clone.Clone.clone.
       T&. T&
      ) (DST (REF T&.)) (TYPE%tuple%1. (REF T&.) T&) (F fndef_singleton) (Poly%tuple%1.
       (tuple%1./tuple%1 a!)
      ) b!
    ))
    :pattern ((vstd!pervasive.strictly_cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.strictly_cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.strictly_cloned.?_definition
))))

;; Function-Axioms vstd::pervasive::cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.cloned.? T&. T& a! b!) (or
      (vstd!pervasive.strictly_cloned.? T&. T& a! b!)
      (= a! b!)
    ))
    :pattern ((vstd!pervasive.cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.cloned.?_definition
))))

;; Function-Specs core::array::impl&%20::clone
(declare-fun ens%core!array.impl&%20.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (res! Poly)) (!
   (= (ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!) (and
     (ens%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&) a! res!)
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (const_int N&))
         ))
         (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
            $ (ARRAY T&. T& N&. N&) a!
           ) i$
          ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
           i$
       ))))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          a!
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          res!
         ) i$
       ))
       :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
           $ (ARRAY T&. T& N&. N&) a!
          ) i$
         ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
          i$
       )))
       :qid user_core__array__impl&%20__clone_25
       :skolemid skolem_user_core__array__impl&%20__clone_25
     ))
     (=>
      (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
         N&
        ) a!
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
      )
      (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!) (vstd!view.View.view.? $ (ARRAY
         T&. T& N&. N&
        ) res!
   )))))
   :pattern ((ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!))
   :qid internal_ens__core!array.impl&__20.clone._definition
   :skolemid skolem_internal_ens__core!array.impl&__20.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)))
     (has_type res$ (ARRAY T&. T& N&. N&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST (REF $))
      (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
     )
     (let
      ((a$ (%Poly%array%. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
              $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
             ) i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            (Poly%array%. a$)
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            res$
           ) i$
         ))
         :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
             $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
            ) i$
           ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
            i$
         )))
         :qid user_core__array__impl&%20__clone_26
         :skolemid skolem_user_core__array__impl&%20__clone_26
       ))
       (=>
        (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
           N&
          ) (Poly%array%. a$)
         ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
        )
        (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)) (vstd!view.View.view.?
          $ (ARRAY T&. T& N&. N&) res$
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST
      (REF $)
     ) (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__array__impl&%20__clone_27
   :skolemid skolem_user_core__array__impl&%20__clone_27
)))

;; Function-Specs verus_builtin::impl&%5::clone
(declare-fun ens%verus_builtin!impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%5.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (TRACKED T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%5.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__5.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (TRACKED T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED T&.)))
      (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED
        T&.
      ))
     ) (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%5__clone_28
   :skolemid skolem_user_verus_builtin__impl&%5__clone_28
)))

;; Function-Specs verus_builtin::impl&%3::clone
(declare-fun ens%verus_builtin!impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (GHOST T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__3.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (GHOST T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST T&.)))
      (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST
        T&.
      ))
     ) (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%3__clone_29
   :skolemid skolem_user_verus_builtin__impl&%3__clone_29
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::obeys_add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Add::add
(declare-fun req%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%6
     (%B (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_req__core!ops.arith.Add.add._definition
)))
(declare-fun ens%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_ens__core!ops.arith.Add.add._definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::sub_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::obeys_sub_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.SubSpec.obeys_sub_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.obeys_sub_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::sub_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Sub::sub
(declare-fun req%core!ops.arith.Sub.sub. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%7
     (%B (vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Sub.sub._definition
   :skolemid skolem_internal_req__core!ops.arith.Sub.sub._definition
)))
(declare-fun ens%core!ops.arith.Sub.sub. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Sub.sub._definition
   :skolemid skolem_internal_ens__core!ops.arith.Sub.sub._definition
)))

;; Function-Axioms vstd::std_specs::ops::MulSpec::mul_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.MulSpec.mul_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::MulSpec::obeys_mul_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.MulSpec.obeys_mul_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.MulSpec.obeys_mul_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.obeys_mul_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::MulSpec::mul_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.MulSpec.mul_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Mul./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Mul::mul
(declare-fun req%core!ops.arith.Mul.mul. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%8
     (%B (vstd!std_specs.ops.MulSpec.mul_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Mul.mul._definition
   :skolemid skolem_internal_req__core!ops.arith.Mul.mul._definition
)))
(declare-fun ens%core!ops.arith.Mul.mul. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Mul./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.MulSpec.mul_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Mul.mul._definition
   :skolemid skolem_internal_ens__core!ops.arith.Mul.mul._definition
)))

;; Function-Specs alloc::boxed::impl&%13::clone
(declare-fun ens%alloc!boxed.impl&%13.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (b! Poly) (res! Poly)) (!
   (= (ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!) (and
     (ens%core!clone.Clone.clone. (BOX A&. A& T&.) T& b! res!)
     (vstd!pervasive.cloned.? T&. T& b! res!)
   ))
   :pattern ((ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!))
   :qid internal_ens__alloc!boxed.impl&__13.clone._definition
   :skolemid skolem_internal_ens__alloc!boxed.impl&__13.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF (BOX A&. A&
         T&.
       ))
      ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (vstd!pervasive.cloned.? T&. T& b$ res$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF
       (BOX A&. A& T&.)
      )
     ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__boxed__impl&%13__clone_30
   :skolemid skolem_user_alloc__boxed__impl&%13__clone_30
)))

;; Function-Axioms vstd::pervasive::arbitrary
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!pervasive.arbitrary.? A&. A&) A&)
   :pattern ((vstd!pervasive.arbitrary.? A&. A&))
   :qid internal_vstd!pervasive.arbitrary.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.arbitrary.?_pre_post_definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%3::view
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%3.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%3.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!) (vstd!view.View.view.?
      $ (PTR T&. T&) self!
    ))
    :pattern ((vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__3_trait_impl_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::p
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.p.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.p.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.p.? no%param) (nClip (Sub (vstd!arithmetic.power2.pow2.?
        (I 255)
       ) 19
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.p.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!) (EucMod (%I n!) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 51)) (%I (vstd!seq.Seq.index.? $ (UINT
                  64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
            )))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 102)) (%I (vstd!seq.Seq.index.? $ (UINT
                64
               ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
          )))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 153)) (%I (vstd!seq.Seq.index.? $ (UINT
              64
             ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
        )))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 204)) (%I (vstd!seq.Seq.index.? $ (UINT
            64
           ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 4)
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_mul.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_mul.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_mul.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
)))

;; Function-Specs subtle::ConstantTimeEq::ct_eq
(declare-fun ens%subtle!ConstantTimeEq.ct_eq. (Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (other! Poly) (%return! Poly)) (
   !
   (= (ens%subtle!ConstantTimeEq.ct_eq. Self%&. Self%& self! other! %return!) (has_type
     %return! TYPE%subtle!Choice.
   ))
   :pattern ((ens%subtle!ConstantTimeEq.ct_eq. Self%&. Self%& self! other! %return!))
   :qid internal_ens__subtle!ConstantTimeEq.ct_eq._definition
   :skolemid skolem_internal_ens__subtle!ConstantTimeEq.ct_eq._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::choice_not
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.choice_not. (subtle!Choice.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((a! subtle!Choice.) (c! subtle!Choice.)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.choice_not. a! c!) (= (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.?
      (Poly%subtle!Choice. c!)
     ) (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        a!
   )))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.choice_not. a! c!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.choice_not._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.choice_not._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::choice_or
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.choice_or. (subtle!Choice.
  subtle!Choice. subtle!Choice.
 ) Bool
)
(assert
 (forall ((a! subtle!Choice.) (b! subtle!Choice.) (c! subtle!Choice.)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.choice_or. a! b! c!) (=
     (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
       c!
      )
     ) (or
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        a!
      ))
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        b!
   )))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.choice_or. a! b!
     c!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.choice_or._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.choice_or._definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::u64_5_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
  (forall ((limbs! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!) (forall (
       (i$ Poly)
      ) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) limbs!
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I (%I bit_limit!))))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) limbs!
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_31
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_31
    )))
    :pattern ((curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
  (forall ((fe! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!) (curve25519_dalek!specs.field_specs.u64_5_bounded.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )
      ) bit_limit!
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_neg.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_neg.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          a!
    ))))))
    :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_neg.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_negate_field_element
(declare-fun req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. subtle!Choice.) Bool
)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (choice!
    subtle!Choice.
   )
  ) (!
   (= (req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element.
     pre%a! choice!
    ) (=>
     %%global_location_label%%9
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       pre%a!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element.
     pre%a! choice!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (choice! subtle!Choice.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element.
     pre%a! a! choice!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       a!
      ) (I 54)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        a!
       ) (I 52)
     ))
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= a! pre%a!)
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        a!
       )
      ) (ite
       (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
       ))
       (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
          (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. pre%a!)
       )))
       (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         pre%a!
   ))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element.
     pre%a! a! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_field_element._definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::mask51
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
  (= curve25519_dalek!specs.field_specs_u64.mask51.? 2251799813685247)
))
(assert
 (uInv 64 curve25519_dalek!specs.field_specs_u64.mask51.?)
)

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_reduce
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
)
(declare-fun %%array%%0 (Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   )
  ) (!
   (let
    ((%%x%% (%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
   ))
   :pattern ((%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (uClip 64 (bitand
                (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                     (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (Mul (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 4)
                  ))
                 ) (I 51)
                )
               ) 19
            )))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 1)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 2)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 1)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 3)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 2)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 4)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 3)
                 ))
                ) (I 51)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::negate_field_element
(declare-fun req%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element. a!)
    (=>
     %%global_location_label%%10
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       a!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element.
     a!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (result! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element. a!
     result!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. result!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        result!
       )
      ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       result!
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       result!
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element.
     a! result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_assign_generic
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic.
 (Dcr Type Poly Poly Poly subtle!Choice.) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (pre%a! Poly) (a! Poly) (b! Poly) (choice! subtle!Choice.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic.
     T&. T& pre%a! a! b! choice!
    ) (and
     (has_type a! T&)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= a! pre%a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= a! b!)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic.
     T&. T& pre%a! a! b! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic._definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_square
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_square.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_square.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_square.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I a!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_square.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_sub.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_sub.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (nClip (Add (curve25519_dalek!specs.field_specs_u64.field_canonical.? a!)
           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )
         ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? b!)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_add.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_add.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Add (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_add.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
  (forall ((fe1! Poly) (fe2! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!) (forall
      ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
              ))
             ) i$
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
              ))
             ) i$
           ))
          ) (%I bound!)
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
          ))
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
          ))
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_32
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_32
    )))
    :pattern ((curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!))
    :qid internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Add (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%43::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%43::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%43::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Sub (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%44::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%44::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%44::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%47::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%47::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%47::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%52::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%52::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%52::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%55::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%55::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%55.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%55.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%55::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%55.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%55.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Mul (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%56::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%56::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%56.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%56.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%56::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%56.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%56.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%59::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%59::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%59.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%59.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%59::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%59.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%59.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%64::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%64::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%64.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%64.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%64::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%64.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%64.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::view::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%0.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (REF A&.) A& self!) (vstd!view.View.view.? A&. A& self!))
    )
    :pattern ((vstd!view.View.view.? (REF A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%2::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%2.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%2.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%4::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%4.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%4.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%6::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%6.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%6.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%12::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%12.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%12.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ TYPE%tuple%0. self!) self!)
    :pattern ((vstd!view.View.view.? $ TYPE%tuple%0. self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%14::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%14.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%14.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ BOOL self!) self!)
    :pattern ((vstd!view.View.view.? $ BOOL self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%16::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%16.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%16.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%22::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%22.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%22.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 64) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 64) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%26::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%26.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%26.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ USIZE self!) self!)
    :pattern ((vstd!view.View.view.? $ USIZE self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%32::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%32.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%32.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%42::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%42.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%42.view.)
  (forall ((A0&. Dcr) (A0& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (tr_bound%vstd!view.View. A0&. A0&)
     )
     (= (vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!) (Poly%tuple%1.
       (tuple%1./tuple%1 (vstd!view.View.view.? A0&. A0& (tuple%1./tuple%1/0 (%Poly%tuple%1.
           self!
    )))))))
    :pattern ((vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%44::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%44.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%44.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
     )
     (= (vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!) (Poly%tuple%2.
       (tuple%2./tuple%2 (vstd!view.View.view.? A0&. A0& (tuple%2./tuple%2/0 (%Poly%tuple%2.
           self!
         ))
        ) (vstd!view.View.view.? A1&. A1& (tuple%2./tuple%2/1 (%Poly%tuple%2. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? self! rhs! (I 18446744073709551615)))
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (%I (vstd!seq.Seq.index.?
              $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  a!
               )))
              ) (I 0)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 0)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 1)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 1)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 2)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 2)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 3)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 3)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 4)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 4)
    ))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 54))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? rhs! (I 54))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_sub_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (
          array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (
                  UINT 64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 0)
                )
               ) 36028797018963664
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 1)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 2)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 3)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 4)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 4)
    ))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%11::obeys_mul_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%11::mul_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 54))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? rhs! (I 54))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%11::mul_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%16::ZERO
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.)
  (= curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%16::ONE
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.)
  (= curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::SQRT_M1
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1.)
  (= curve25519_dalek!backend.serial.u64.constants.SQRT_M1.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 1718705420411056) (I 234908883556509)
       (I 2233514472574048) (I 2117202627021982) (I 765476049583133)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.SQRT_M1.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::SQRT_ID
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID.)
  (= curve25519_dalek!lizard.u64_constants.SQRT_ID.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2298852427963285) (I 3837146560810661)
       (I 4413131899466403) (I 3883177008057528) (I 2352084440532925)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.SQRT_ID.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::DP1_OVER_DM1
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.)
  (= curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2159851467815724) (I 1752228607624431)
       (I 1825604053920671) (I 1212587319275468) (I 253422448836237)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::specs::field_specs::sqrt_m1
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sqrt_m1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sqrt_m1.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sqrt_m1.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.SQRT_M1.?)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.sqrt_m1.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs.sqrt_m1.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs.sqrt_m1.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::is_negative
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_negative.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_negative.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_negative.? a!) (= (EucMod (curve25519_dalek!specs.field_specs_u64.field_canonical.?
        a!
       ) 2
      ) 1
    ))
    :pattern ((curve25519_dalek!specs.field_specs.is_negative.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.is_negative.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_negative.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::nat_invsqrt
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.nat_invsqrt.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.nat_invsqrt.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.nat_invsqrt.? a!) (ite
      (= (EucMod (%I a!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
      0
      (let
       ((a3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
            a!
           )
          ) a!
       )))
       (let
        ((a7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
             (I a3$)
            )
           ) a!
        )))
        (let
         ((k$ (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 5) 8))))
         (let
          ((r_raw$ (curve25519_dalek!specs.field_specs.field_mul.? (I a3$) (I (EucMod (nClip (vstd!arithmetic.power.pow.?
                 (I a7$) (I k$)
                )
               ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )))))
          (let
           ((check$ (curve25519_dalek!specs.field_specs.field_mul.? a! (I (curve25519_dalek!specs.field_specs.field_square.?
                (I r_raw$)
           )))))
           (let
            ((neg_one$ (curve25519_dalek!specs.field_specs.field_neg.? (I 1))))
            (let
             ((neg_i$ (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                  (I 0)
             )))))
             (let
              ((r_adj$ (ite
                 (or
                  (= check$ neg_one$)
                  (= check$ neg_i$)
                 )
                 (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                    (I 0)
                   )
                  ) (I r_raw$)
                 )
                 r_raw$
              )))
              (ite
               (curve25519_dalek!specs.field_specs.is_negative.? (I r_adj$))
               (curve25519_dalek!specs.field_specs.field_neg.? (I r_adj$))
               r_adj$
    )))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.nat_invsqrt.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.nat_invsqrt.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.nat_invsqrt.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_abs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_abs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_abs.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_abs.? a!) (ite
      (curve25519_dalek!specs.field_specs.is_negative.? a!)
      (curve25519_dalek!specs.field_specs.field_neg.? a!)
      (%I a!)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_abs.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_abs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_abs.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_abs.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_abs.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_abs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_abs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::is_sqrt_ratio
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio.)
  (forall ((u! Poly) (v! Poly) (r! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? u! v! r!) (= (curve25519_dalek!specs.field_specs_u64.field_canonical.?
       (I (nClip (Mul (nClip (Mul (%I r!) (%I r!))) (%I v!))))
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? u!)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.is_sqrt_ratio.? u! v! r!))
    :qid internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_fe51_as_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.)
)
(declare-fun %%array%%1 (Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
  Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
  Poly Poly Poly
 ) %%Function%%
)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (%%hole%%5 Poly) (%%hole%%6 Poly) (%%hole%%7 Poly) (%%hole%%8 Poly) (%%hole%%9 Poly)
   (%%hole%%10 Poly) (%%hole%%11 Poly) (%%hole%%12 Poly) (%%hole%%13 Poly) (%%hole%%14
    Poly
   ) (%%hole%%15 Poly) (%%hole%%16 Poly) (%%hole%%17 Poly) (%%hole%%18 Poly) (%%hole%%19
    Poly
   ) (%%hole%%20 Poly) (%%hole%%21 Poly) (%%hole%%22 Poly) (%%hole%%23 Poly) (%%hole%%24
    Poly
   ) (%%hole%%25 Poly) (%%hole%%26 Poly) (%%hole%%27 Poly) (%%hole%%28 Poly) (%%hole%%29
    Poly
   ) (%%hole%%30 Poly) (%%hole%%31 Poly)
  ) (!
   (let
    ((%%x%% (%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
       %%hole%%7 %%hole%%8 %%hole%%9 %%hole%%10 %%hole%%11 %%hole%%12 %%hole%%13 %%hole%%14
       %%hole%%15 %%hole%%16 %%hole%%17 %%hole%%18 %%hole%%19 %%hole%%20 %%hole%%21 %%hole%%22
       %%hole%%23 %%hole%%24 %%hole%%25 %%hole%%26 %%hole%%27 %%hole%%28 %%hole%%29 %%hole%%30
       %%hole%%31
    )))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
     (= (%%apply%%1 %%x%% 5) %%hole%%5)
     (= (%%apply%%1 %%x%% 6) %%hole%%6)
     (= (%%apply%%1 %%x%% 7) %%hole%%7)
     (= (%%apply%%1 %%x%% 8) %%hole%%8)
     (= (%%apply%%1 %%x%% 9) %%hole%%9)
     (= (%%apply%%1 %%x%% 10) %%hole%%10)
     (= (%%apply%%1 %%x%% 11) %%hole%%11)
     (= (%%apply%%1 %%x%% 12) %%hole%%12)
     (= (%%apply%%1 %%x%% 13) %%hole%%13)
     (= (%%apply%%1 %%x%% 14) %%hole%%14)
     (= (%%apply%%1 %%x%% 15) %%hole%%15)
     (= (%%apply%%1 %%x%% 16) %%hole%%16)
     (= (%%apply%%1 %%x%% 17) %%hole%%17)
     (= (%%apply%%1 %%x%% 18) %%hole%%18)
     (= (%%apply%%1 %%x%% 19) %%hole%%19)
     (= (%%apply%%1 %%x%% 20) %%hole%%20)
     (= (%%apply%%1 %%x%% 21) %%hole%%21)
     (= (%%apply%%1 %%x%% 22) %%hole%%22)
     (= (%%apply%%1 %%x%% 23) %%hole%%23)
     (= (%%apply%%1 %%x%% 24) %%hole%%24)
     (= (%%apply%%1 %%x%% 25) %%hole%%25)
     (= (%%apply%%1 %%x%% 26) %%hole%%26)
     (= (%%apply%%1 %%x%% 27) %%hole%%27)
     (= (%%apply%%1 %%x%% 28) %%hole%%28)
     (= (%%apply%%1 %%x%% 29) %%hole%%29)
     (= (%%apply%%1 %%x%% 30) %%hole%%30)
     (= (%%apply%%1 %%x%% 31) %%hole%%31)
   ))
   :pattern ((%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
     %%hole%%7 %%hole%%8 %%hole%%9 %%hole%%10 %%hole%%11 %%hole%%12 %%hole%%13 %%hole%%14
     %%hole%%15 %%hole%%16 %%hole%%17 %%hole%%18 %%hole%%19 %%hole%%20 %%hole%%21 %%hole%%22
     %%hole%%23 %%hole%%24 %%hole%%25 %%hole%%26 %%hole%%27 %%hole%%28 %%hole%%29 %%hole%%30
     %%hole%%31
   ))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? fe!) (%Poly%vstd!seq.Seq<u8.>.
      (let
       ((limbs$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )))))
       (let
        ((q0$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                 ) (I 0)
                )
               ) 19
             ))
            ) (I 51)
        ))))
        (let
         ((q1$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                  ) (I 1)
                 )
                ) q0$
              ))
             ) (I 51)
         ))))
         (let
          ((q2$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                   ) (I 2)
                  )
                 ) q1$
               ))
              ) (I 51)
          ))))
          (let
           ((q3$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                    ) (I 3)
                   )
                  ) q2$
                ))
               ) (I 51)
           ))))
           (let
            ((q$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                     ) (I 4)
                    )
                   ) q3$
                 ))
                ) (I 51)
            ))))
            (let
             ((limbs0_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                   ) (I 0)
                  )
                 ) (Mul 19 q$)
             ))))
             (let
              ((limbs1_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                    ) (I 1)
                   )
                  ) (uClip 64 (bitshr (I limbs0_adj$) (I 51)))
              ))))
              (let
               ((limbs0_canon$ (uClip 64 (uClip 64 (bitand (I limbs0_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
               (let
                ((limbs2_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                       $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                      ) (I 2)
                     )
                    ) (uClip 64 (bitshr (I limbs1_adj$) (I 51)))
                ))))
                (let
                 ((limbs1_canon$ (uClip 64 (uClip 64 (bitand (I limbs1_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                 (let
                  ((limbs3_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                        ) (I 3)
                       )
                      ) (uClip 64 (bitshr (I limbs2_adj$) (I 51)))
                  ))))
                  (let
                   ((limbs2_canon$ (uClip 64 (uClip 64 (bitand (I limbs2_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                   (let
                    ((limbs4_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                          ) (I 4)
                         )
                        ) (uClip 64 (bitshr (I limbs3_adj$) (I 51)))
                    ))))
                    (let
                     ((limbs3_canon$ (uClip 64 (uClip 64 (bitand (I limbs3_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                     (let
                      ((limbs4_canon$ (uClip 64 (uClip 64 (bitand (I limbs4_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                      (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (array_new $ (UINT 8)
                        32 (%%array%%1 (I (uClip 8 limbs0_canon$)) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$)
                             (I 8)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$) (I 16))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs0_canon$) (I 24)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$) (I 32))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs0_canon$) (I 40)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I limbs0_canon$) (I 48)))) (I (uClip
                               64 (bitshl (I limbs1_canon$) (I 3))
                          )))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 5))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs1_canon$) (I 13)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 21))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs1_canon$) (I 29)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 37))))) (I (uClip 8 (uClip 64 (
                             bitor (I (uClip 64 (bitshr (I limbs1_canon$) (I 45)))) (I (uClip 64 (bitshl (I limbs2_canon$)
                                (I 6)
                          ))))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 2))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs2_canon$) (I 10)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 18))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs2_canon$) (I 26)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 34))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs2_canon$) (I 42)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I limbs2_canon$) (I 50)))) (I (uClip
                               64 (bitshl (I limbs3_canon$) (I 1))
                          )))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 7))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs3_canon$) (I 15)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 23))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs3_canon$) (I 31)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 39))))) (I (uClip 8 (uClip 64 (
                             bitor (I (uClip 64 (bitshr (I limbs3_canon$) (I 47)))) (I (uClip 64 (bitshl (I limbs4_canon$)
                                (I 4)
                          ))))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 4))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs4_canon$) (I 12)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 20))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs4_canon$) (I 28)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 36))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs4_canon$) (I 44)
    )))))))))))))))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::is_sqrt_ratio_times_i
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.)
  (forall ((u! Poly) (v! Poly) (r! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? u! v! r!) (= (curve25519_dalek!specs.field_specs_u64.field_canonical.?
       (I (nClip (Mul (nClip (Mul (%I r!) (%I r!))) (%I v!))))
      ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
         (I 0)
        )
       ) u!
    )))
    :pattern ((curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? u! v! r!))
    :qid internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_is_sqrt_ratio
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.)
  (forall ((u! Poly) (v! Poly) (r! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.? u! v! r!) (curve25519_dalek!specs.field_specs.is_sqrt_ratio.?
      (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? u!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
        v!
       )
      ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? r!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.? u! v! r!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_is_sqrt_ratio_times_i
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.)
  (forall ((u! Poly) (v! Poly) (r! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.? u! v! r!) (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.?
      (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? u!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
        v!
       )
      ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? r!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.? u! v! r!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::sqrt_id
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.sqrt_id.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.sqrt_id.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.SQRT_ID.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::dp1_over_dm1
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_elligator_inv
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((s! Poly) (t! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. s! t!) (and
     (=>
      %%global_location_label%%11
      (< (%I s!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%12
      (< (%I t!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. s! t!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_elligator_inv._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_elligator_inv._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_elligator_inv
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_elligator_inv.)
  (forall ((s! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s! t!) (ite
      (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? s!) 0)
      (ite
       (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? t!) 1)
       (tuple%2./tuple%2 (B true) (I (curve25519_dalek!specs.lizard_specs.sqrt_id.? (I 0))))
       (tuple%2./tuple%2 (B true) (I 0))
      )
      (let
       ((a$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
            t! (I 1)
           )
          ) (I (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? (I 0)))
       )))
       (let
        ((s2$ (curve25519_dalek!specs.field_specs.field_square.? s!)))
        (let
         ((s4$ (curve25519_dalek!specs.field_specs.field_square.? (I s2$))))
         (let
          ((inv_sq_y$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
               (I s4$) (I (curve25519_dalek!specs.field_specs.field_square.? (I a$)))
              )
             ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
          )))
          (let
           ((y$ (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I inv_sq_y$))))
           (let
            ((sq$ (and
               (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I inv_sq_y$)) 0))
               (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I inv_sq_y$) (I y$))
            )))
            (ite
             (not sq$)
             (tuple%2./tuple%2 (B false) (I 0))
             (let
              ((pms2$ (ite
                 (curve25519_dalek!specs.field_specs.is_negative.? s!)
                 (curve25519_dalek!specs.field_specs.field_neg.? (I s2$))
                 s2$
              )))
              (let
               ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                    (I a$) (I pms2$)
                   )
                  ) (I y$)
               )))
               (tuple%2./tuple%2 (B true) (I (curve25519_dalek!specs.field_specs.field_abs.? (I x$))))
    )))))))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s! t!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_definition
))))
(assert
 (forall ((s! Poly) (t! Poly)) (!
   (=>
    (and
     (has_type s! NAT)
     (has_type t! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s!
       t!
      )
     ) (TYPE%tuple%2. $ BOOL $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s! t!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (REF A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (REF A&.) A&))
   :qid internal_vstd__view__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__6_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (=>
    (and
     (sized A0&.)
     (tr_bound%vstd!view.View. A0&. A0&)
    )
    (tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_vstd__view__impl&__42_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__42_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
    )
    (tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_vstd__view__impl&__44_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. $ (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. $ (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (REF T&.) T&)
   :pattern ((tr_bound%core!clone.Clone. (REF T&.) T&))
   :qid internal_core__clone__impls__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__20_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__20_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!alloc.Allocator. A&. A&)
    (tr_bound%core!alloc.Allocator. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!alloc.Allocator. (REF A&.) A&))
   :qid internal_core__alloc__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__alloc__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (TRACKED A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (TRACKED A&.) A&))
   :qid internal_verus_builtin__impl&__5_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (GHOST A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (GHOST A&.) A&))
   :qid internal_verus_builtin__impl&__3_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!clone.Clone. A&. A&)
    )
    (tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&)
   )
   :pattern ((tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&))
   :qid internal_alloc__boxed__impl&__13_trait_impl_definition
   :skolemid skolem_internal_alloc__boxed__impl&__13_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::field::FieldElement::ct_eq
(declare-fun ens%curve25519_dalek!field.impl&%3.ct_eq. (Poly Poly Poly) Bool)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!field.impl&%3.ct_eq. self! other! result!) (and
     (ens%subtle!ConstantTimeEq.ct_eq. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self! other! result!
     )
     (= (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? result!) (
       = (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? self!) (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?
        other!
   )))))
   :pattern ((ens%curve25519_dalek!field.impl&%3.ct_eq. self! other! result!))
   :qid internal_ens__curve25519_dalek!field.impl&__3.ct_eq._definition
   :skolemid skolem_internal_ens__curve25519_dalek!field.impl&__3.ct_eq._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%subtle!ConstantTimeEq. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::constants_lemmas::lemma_one_field_element_value
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_field_element_value.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_field_element_value.
     no%param
    ) (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.?
      )
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_field_element_value.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_field_element_value._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_field_element_value._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::constants_lemmas::lemma_zero_field_element_value
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_zero_field_element_value.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_zero_field_element_value.
     no%param
    ) (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.?
      )
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_zero_field_element_value.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_zero_field_element_value._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_zero_field_element_value._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::constants_lemmas::lemma_one_limbs_bounded_51
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_limbs_bounded_51.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_limbs_bounded_51.
     no%param
    ) (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.?
     ) (I 51)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_limbs_bounded_51.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_limbs_bounded_51._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_one_limbs_bounded_51._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_fe51_limbs_bounded_weaken
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int Int) Bool
)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! Int) (
    b! Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
    ) (and
     (=>
      %%global_location_label%%13
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       ) (I a!)
     ))
     (=>
      %%global_location_label%%14
      (< a! b!)
     )
     (=>
      %%global_location_label%%15
      (<= b! 63)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int Int) Bool
)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! Int) (
    b! Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
    ) (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      fe!
     ) (I b!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_sum_of_limbs_bounded_from_fe51_bounded
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  Int
 ) Bool
)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (n! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
    ) (and
     (=>
      %%global_location_label%%16
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        a!
       ) (I n!)
     ))
     (=>
      %%global_location_label%%17
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        b!
       ) (I n!)
     ))
     (=>
      %%global_location_label%%18
      (<= n! 62)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  Int
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (n! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
    ) (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      a!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!) (I 18446744073709551615)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%6::add
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? output!) (nClip (Add (curve25519_dalek!specs.field_specs.fe51_as_nat.?
         self!
        ) (curve25519_dalek!specs.field_specs.fe51_as_nat.? _rhs!)
     )))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_add.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 51))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 51))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     )
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 52))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 52))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 53))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%9::sub
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_sub.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 54))
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__9.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__9.sub._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::square
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%16.square. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self!) (=>
     %%global_location_label%%19
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self!))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (r! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self! r!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 54)
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (vstd!arithmetic.power.pow.?
          (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                self!
           )))))
          ) (I 2)
   )))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%12::mul
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%12.mul. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%12.mul. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Mul.mul. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_mul.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 54))
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%12.mul. self! _rhs!
     output!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__12.mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__12.mul._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_square_matches_field_square
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square.
 (Int Int) Bool
)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((y_raw! Int) (y2_raw! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square.
     y_raw! y2_raw!
    ) (=>
     %%global_location_label%%20
     (= (EucMod y2_raw! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod (nClip
        (vstd!arithmetic.power.pow.? (I y_raw!) (I 2))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square.
     y_raw! y2_raw!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square.
 (Int Int) Bool
)
(assert
 (forall ((y_raw! Int) (y2_raw! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square.
     y_raw! y2_raw!
    ) (= (EucMod y2_raw! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (curve25519_dalek!specs.field_specs.field_square.?
      (I (EucMod y_raw! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square.
     y_raw! y2_raw!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_matches_field_square._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::as_bytes_lemmas::lemma_ct_eq_iff_canonical_nat
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_ct_eq_iff_canonical_nat.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_ct_eq_iff_canonical_nat.
     a! b!
    ) (= (= (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        a!
       )
      ) (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        b!
      ))
     ) (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        a!
       )
      ) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        b!
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_ct_eq_iff_canonical_nat.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_ct_eq_iff_canonical_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_ct_eq_iff_canonical_nat._definition
)))

;; Function-Specs curve25519_dalek::lizard::jacobi_quartic::JacobiPoint::clone
(declare-fun ens%curve25519_dalek!lizard.jacobi_quartic.impl&%1.clone. (Poly Poly)
 Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!lizard.jacobi_quartic.impl&%1.clone. self! %return!) (and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!lizard.jacobi_quartic.impl&%1.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!lizard.jacobi_quartic.impl&__1.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lizard.jacobi_quartic.impl&__1.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.))
     (has_type %return$ TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. %return$) self$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__lizard__jacobi_quartic__JacobiPoint__clone_33
   :skolemid skolem_user_curve25519_dalek__lizard__jacobi_quartic__JacobiPoint__clone_33
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::clone
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. (Poly Poly)
 Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. self! %return!) (
     and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__1.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__1.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
     (has_type %return$ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. %return$) self$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__backend__serial__u64__field__FieldElement51__clone_34
   :skolemid skolem_user_curve25519_dalek__backend__serial__u64__field__FieldElement51__clone_34
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%subtle!ConstantTimeEq. T&. T&)
    )
    (tr_bound%subtle!ConstantTimeEq. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%subtle!ConstantTimeEq. $slice (SLICE T&. T&)))
   :qid internal_subtle__impl&__10_trait_impl_definition
   :skolemid skolem_internal_subtle__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%subtle!ConstantTimeEq. $ TYPE%subtle!Choice.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%subtle!ConstantTimeEq. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%subtle!ConstantTimeEq. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%subtle!ConstantTimeEq. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%subtle!ConstantTimeEq. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Add. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.AddSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Sub. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.SubSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.SubSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Mul. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.MulSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.MulSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__4_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_sqrt_m1_limbs_bounded
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_limbs_bounded.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_limbs_bounded.
     no%param
    ) (and
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       curve25519_dalek!backend.serial.u64.constants.SQRT_M1.?
      ) (I 51)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       curve25519_dalek!backend.serial.u64.constants.SQRT_M1.?
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_limbs_bounded.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_limbs_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_limbs_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_invsqrt_unique
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
 (Int Int) Bool
)
(declare-const %%global_location_label%%21 Bool)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((a! Int) (r! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
    ) (and
     (=>
      %%global_location_label%%21
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%22
      (< r! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%23
      (not (curve25519_dalek!specs.field_specs.is_negative.? (I r!)))
     )
     (=>
      %%global_location_label%%24
      (or
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I a!) (I r!))
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I 1) (I a!) (I r!))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
    ) (= r! (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I a!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_sqrt_ratio_mutual_exclusion
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((u! Int) (v! Int) (r! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
    ) (=>
     %%global_location_label%%25
     (not (= (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
 (Int Int Int) Bool
)
(assert
 (forall ((u! Int) (v! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
    ) (not (and
      (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I u!) (I v!) (I r!))
      (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I u!) (I v!) (I r!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_canonical_nat_lt_p
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(assert
 (forall ((x! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p.
     x!
    ) (< (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x!
      )
     ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_is_negative_bridge
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int) Bool
)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (n! Int))
  (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge.
     fe! n!
    ) (=>
     %%global_location_label%%26
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       )
      ) n!
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge.
     fe! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int) Bool
)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (n! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge.
     fe! n!
    ) (= (= (uClip 8 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
            (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
            ))
           ) (I 0)
         ))
        ) (I 1)
       )
      ) 1
     ) (curve25519_dalek!specs.field_specs.is_negative.? (I n!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge.
     fe! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_negative_bridge._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::batch_invert_lemmas::lemma_is_zero_iff_canonical_nat_zero
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.batch_invert_lemmas.lemma_is_zero_iff_canonical_nat_zero.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(declare-fun %%lambda%%1 (Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (_x$ Poly)) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0) _x$) %%hole%%0)
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0) _x$))
)))
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.batch_invert_lemmas.lemma_is_zero_iff_canonical_nat_zero.
     fe!
    ) (= (= (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       )
      ) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.? $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT
          8
         )
        ) (I 32) (Poly%fun%1. (mk_fun (%%lambda%%1 (I 0))))
      ))
     ) (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       )
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.batch_invert_lemmas.lemma_is_zero_iff_canonical_nat_zero.
     fe!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.batch_invert_lemmas.lemma_is_zero_iff_canonical_nat_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.batch_invert_lemmas.lemma_is_zero_iff_canonical_nat_zero._definition
)))

;; Function-Specs curve25519_dalek::lizard::jacobi_quartic::lemma_elligator_inv_spec_anchor
(declare-fun req%curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor.
 (Int Int Bool Int Bool Bool Bool Int Int Int Int Int Int Bool Int Int) Bool
)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(assert
 (forall ((gs! Int) (gt! Int) (ret_val! Bool) (out_nat! Int) (s_is_zero! Bool) (t_equals_one!
    Bool
   ) (sq_val! Bool) (a_nat! Int) (s2_nat! Int) (s4_nat! Int) (a2_nat! Int) (inv_sq_y_nat!
    Int
   ) (y_nat! Int) (s_is_neg! Bool) (pms2_nat! Int) (x_before_negate_nat! Int)
  ) (!
   (= (req%curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor. gs!
     gt! ret_val! out_nat! s_is_zero! t_equals_one! sq_val! a_nat! s2_nat! s4_nat! a2_nat!
     inv_sq_y_nat! y_nat! s_is_neg! pms2_nat! x_before_negate_nat!
    ) (and
     (=>
      %%global_location_label%%27
      (< gs! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%28
      (< gt! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%29
      (< inv_sq_y_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%30
      (< y_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%31
      (= s_is_zero! (= gs! 0))
     )
     (=>
      %%global_location_label%%32
      (= t_equals_one! (= gt! 1))
     )
     (=>
      %%global_location_label%%33
      (=>
       (and
        s_is_zero!
        t_equals_one!
       )
       (and
        ret_val!
        (= out_nat! (curve25519_dalek!specs.lizard_specs.sqrt_id.? (I 0)))
     )))
     (=>
      %%global_location_label%%34
      (=>
       (and
        s_is_zero!
        (not t_equals_one!)
       )
       (and
        ret_val!
        (= out_nat! 0)
     )))
     (=>
      %%global_location_label%%35
      (= a_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
          (I gt!) (I 1)
         )
        ) (I (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? (I 0)))
     )))
     (=>
      %%global_location_label%%36
      (= s2_nat! (curve25519_dalek!specs.field_specs.field_square.? (I gs!)))
     )
     (=>
      %%global_location_label%%37
      (= s4_nat! (curve25519_dalek!specs.field_specs.field_square.? (I s2_nat!)))
     )
     (=>
      %%global_location_label%%38
      (= a2_nat! (curve25519_dalek!specs.field_specs.field_square.? (I a_nat!)))
     )
     (=>
      %%global_location_label%%39
      (= inv_sq_y_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
          (I s4_nat!) (I a2_nat!)
         )
        ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     )))
     (=>
      %%global_location_label%%40
      (= (EucMod y_nat! 2) 0)
     )
     (=>
      %%global_location_label%%41
      (=>
       sq_val!
       (and
        (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I inv_sq_y_nat!) (I y_nat!))
        (not (= inv_sq_y_nat! 0))
     )))
     (=>
      %%global_location_label%%42
      (=>
       (and
        (not s_is_zero!)
        sq_val!
       )
       ret_val!
     ))
     (=>
      %%global_location_label%%43
      (=>
       (and
        (not s_is_zero!)
        sq_val!
       )
       (= s_is_neg! (curve25519_dalek!specs.field_specs.is_negative.? (I gs!)))
     ))
     (=>
      %%global_location_label%%44
      (=>
       (and
        (not s_is_zero!)
        sq_val!
       )
       (= pms2_nat! (ite
         s_is_neg!
         (curve25519_dalek!specs.field_specs.field_neg.? (I s2_nat!))
         s2_nat!
     ))))
     (=>
      %%global_location_label%%45
      (=>
       (and
        (not s_is_zero!)
        sq_val!
       )
       (= x_before_negate_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
           (I a_nat!) (I pms2_nat!)
          )
         ) (I y_nat!)
     ))))
     (=>
      %%global_location_label%%46
      (=>
       (and
        (not s_is_zero!)
        sq_val!
       )
       (= out_nat! (curve25519_dalek!specs.field_specs.field_abs.? (I x_before_negate_nat!)))
     ))
     (=>
      %%global_location_label%%47
      (=>
       (and
        (not s_is_zero!)
        (not sq_val!)
       )
       (not ret_val!)
     ))
     (=>
      %%global_location_label%%48
      (=>
       (and
        (and
         (not s_is_zero!)
         (not sq_val!)
        )
        (not (= inv_sq_y_nat! 0))
       )
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I 1) (I inv_sq_y_nat!)
        (I y_nat!)
     )))
     (=>
      %%global_location_label%%49
      (=>
       (and
        (and
         (not s_is_zero!)
         (not sq_val!)
        )
        (not (= inv_sq_y_nat! 0))
       )
       (not (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I inv_sq_y_nat!) (I
          y_nat!
   )))))))
   :pattern ((req%curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor.
     gs! gt! ret_val! out_nat! s_is_zero! t_equals_one! sq_val! a_nat! s2_nat! s4_nat!
     a2_nat! inv_sq_y_nat! y_nat! s_is_neg! pms2_nat! x_before_negate_nat!
   ))
   :qid internal_req__curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor._definition
)))
(declare-fun ens%curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor.
 (Int Int Bool Int Bool Bool Bool Int Int Int Int Int Int Bool Int Int) Bool
)
(assert
 (forall ((gs! Int) (gt! Int) (ret_val! Bool) (out_nat! Int) (s_is_zero! Bool) (t_equals_one!
    Bool
   ) (sq_val! Bool) (a_nat! Int) (s2_nat! Int) (s4_nat! Int) (a2_nat! Int) (inv_sq_y_nat!
    Int
   ) (y_nat! Int) (s_is_neg! Bool) (pms2_nat! Int) (x_before_negate_nat! Int)
  ) (!
   (= (ens%curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor. gs!
     gt! ret_val! out_nat! s_is_zero! t_equals_one! sq_val! a_nat! s2_nat! s4_nat! a2_nat!
     inv_sq_y_nat! y_nat! s_is_neg! pms2_nat! x_before_negate_nat!
    ) (and
     (= ret_val! (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?
           (I gs!) (I gt!)
     ))))))
     (=>
      ret_val!
      (= out_nat! (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?
            (I gs!) (I gt!)
   )))))))))
   :pattern ((ens%curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor.
     gs! gt! ret_val! out_nat! s_is_zero! t_equals_one! sq_val! a_nat! s2_nat! s4_nat!
     a2_nat! inv_sq_y_nat! y_nat! s_is_neg! pms2_nat! x_before_negate_nat!
   ))
   :qid internal_ens__curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lizard.jacobi_quartic.lemma_elligator_inv_spec_anchor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::lizard_lemmas::lemma_zero_limbs_bounded
(declare-fun ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded. (
  Int
 ) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded. no%param)
    (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.?
     ) (I 52)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::lizard_lemmas::lemma_sqrt_id_limbs_bounded_52
(declare-fun ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52. no%param)
    (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!lizard.u64_constants.SQRT_ID.?
     ) (I 52)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52._definition
)))

;; Function-Specs curve25519_dalek::lemmas::lizard_lemmas::lemma_dp1_over_dm1_limbs_bounded_51
(declare-fun ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51.
     no%param
    ) (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.?
     ) (I 51)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51._definition
)))

;; Function-Specs curve25519_dalek::field::FieldElement::is_zero
(declare-fun ens%curve25519_dalek!field.impl&%4.is_zero. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (result!
    subtle!Choice.
   )
  ) (!
   (= (ens%curve25519_dalek!field.impl&%4.is_zero. self! result!) (= (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.?
      (Poly%subtle!Choice. result!)
     ) (= (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       )
      ) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.? $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT
          8
         )
        ) (I 32) (Poly%fun%1. (mk_fun (%%lambda%%1 (I 0))))
   )))))
   :pattern ((ens%curve25519_dalek!field.impl&%4.is_zero. self! result!))
   :qid internal_ens__curve25519_dalek!field.impl&__4.is_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!field.impl&__4.is_zero._definition
)))

;; Function-Specs curve25519_dalek::field::FieldElement::is_negative
(declare-fun ens%curve25519_dalek!field.impl&%4.is_negative. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (result!
    subtle!Choice.
   )
  ) (!
   (= (ens%curve25519_dalek!field.impl&%4.is_negative. self! result!) (= (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.?
      (Poly%subtle!Choice. result!)
     ) (= (uClip 8 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (
             curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              self!
            ))
           ) (I 0)
         ))
        ) (I 1)
       )
      ) 1
   )))
   :pattern ((ens%curve25519_dalek!field.impl&%4.is_negative. self! result!))
   :qid internal_ens__curve25519_dalek!field.impl&__4.is_negative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!field.impl&__4.is_negative._definition
)))

;; Function-Specs curve25519_dalek::field::FieldElement::invsqrt
(declare-fun req%curve25519_dalek!field.impl&%4.invsqrt. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!field.impl&%4.invsqrt. self!) (=>
     %%global_location_label%%50
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!field.impl&%4.invsqrt. self!))
   :qid internal_req__curve25519_dalek!field.impl&__4.invsqrt._definition
   :skolemid skolem_internal_req__curve25519_dalek!field.impl&__4.invsqrt._definition
)))
(declare-fun ens%curve25519_dalek!field.impl&%4.invsqrt. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  tuple%2.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (result!
    tuple%2.
   )
  ) (!
   (= (ens%curve25519_dalek!field.impl&%4.invsqrt. self! result!) (and
     (has_type (Poly%tuple%2. result!) (TYPE%tuple%2. $ TYPE%subtle!Choice. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
     (=>
      (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         self!
        )
       ) 0
      )
      (and
       (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. result!))
       )))
       (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (tuple%2./tuple%2/1 (
           %Poly%tuple%2. (Poly%tuple%2. result!)
         ))
        ) 0
     )))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. result!))
      ))
      (curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.?
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) (tuple%2./tuple%2/1
        (%Poly%tuple%2. (Poly%tuple%2. result!))
     )))
     (=>
      (and
       (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. result!))
       )))
       (not (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           self!
          )
         ) 0
      )))
      (curve25519_dalek!specs.field_specs.fe51_is_sqrt_ratio_times_i.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.?
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) (tuple%2./tuple%2/1
        (%Poly%tuple%2. (Poly%tuple%2. result!))
     )))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (tuple%2./tuple%2/1 (%Poly%tuple%2.
        (Poly%tuple%2. result!)
       )
      ) (I 52)
     )
     (= (EucMod (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (tuple%2./tuple%2/1
         (%Poly%tuple%2. (Poly%tuple%2. result!))
        )
       ) 2
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!field.impl&%4.invsqrt. self! result!))
   :qid internal_ens__curve25519_dalek!field.impl&__4.invsqrt._definition
   :skolemid skolem_internal_ens__curve25519_dalek!field.impl&__4.invsqrt._definition
)))

;; Function-Specs curve25519_dalek::lizard::jacobi_quartic::JacobiPoint::elligator_inv
(declare-fun req%curve25519_dalek!lizard.jacobi_quartic.impl&%2.elligator_inv. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 Bool
)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((self! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)) (!
   (= (req%curve25519_dalek!lizard.jacobi_quartic.impl&%2.elligator_inv. self!) (and
     (=>
      %%global_location_label%%51
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
          (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
        ))
       ) (I 52)
     ))
     (=>
      %%global_location_label%%52
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
          (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
        ))
       ) (I 52)
   ))))
   :pattern ((req%curve25519_dalek!lizard.jacobi_quartic.impl&%2.elligator_inv. self!))
   :qid internal_req__curve25519_dalek!lizard.jacobi_quartic.impl&__2.elligator_inv._definition
   :skolemid skolem_internal_req__curve25519_dalek!lizard.jacobi_quartic.impl&__2.elligator_inv._definition
)))
(declare-fun ens%curve25519_dalek!lizard.jacobi_quartic.impl&%2.elligator_inv. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
  tuple%2.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.) (result! tuple%2.))
  (!
   (= (ens%curve25519_dalek!lizard.jacobi_quartic.impl&%2.elligator_inv. self! result!)
    (and
     (has_type (Poly%tuple%2. result!) (TYPE%tuple%2. $ TYPE%subtle!Choice. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (tuple%2./tuple%2/1 (%Poly%tuple%2.
        (Poly%tuple%2. result!)
       )
      ) (I 52)
     )
     (= (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. result!))
       )
      ) (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?
           (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
            ))))
           ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
     )))))))))))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. result!))
      ))
      (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (tuple%2./tuple%2/1 (
          %Poly%tuple%2. (Poly%tuple%2. result!)
        ))
       ) (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?
            (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                 (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
             ))))
            ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                 (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
   ))))))))))))))
   :pattern ((ens%curve25519_dalek!lizard.jacobi_quartic.impl&%2.elligator_inv. self!
     result!
   ))
   :qid internal_ens__curve25519_dalek!lizard.jacobi_quartic.impl&__2.elligator_inv._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lizard.jacobi_quartic.impl&__2.elligator_inv._definition
)))

;; Function-Specs curve25519_dalek::lizard::jacobi_quartic::JacobiPoint::dual
(declare-fun req%curve25519_dalek!lizard.jacobi_quartic.impl&%2.dual. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 Bool
)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((self! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)) (!
   (= (req%curve25519_dalek!lizard.jacobi_quartic.impl&%2.dual. self!) (and
     (=>
      %%global_location_label%%53
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
          (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%54
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
          (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
        ))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!lizard.jacobi_quartic.impl&%2.dual. self!))
   :qid internal_req__curve25519_dalek!lizard.jacobi_quartic.impl&__2.dual._definition
   :skolemid skolem_internal_req__curve25519_dalek!lizard.jacobi_quartic.impl&__2.dual._definition
)))
(declare-fun ens%curve25519_dalek!lizard.jacobi_quartic.impl&%2.dual. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
  curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.) (result! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.))
  (!
   (= (ens%curve25519_dalek!lizard.jacobi_quartic.impl&%2.dual. self! result!) (and
     (has_type (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
         (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
       ))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
         (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
       ))
      ) (I 52)
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
          (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
       )))
      ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S
           (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
             self!
     ))))))))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
          (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
       )))
      ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T
           (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
             self!
   ))))))))))
   :pattern ((ens%curve25519_dalek!lizard.jacobi_quartic.impl&%2.dual. self! result!))
   :qid internal_ens__curve25519_dalek!lizard.jacobi_quartic.impl&__2.dual._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lizard.jacobi_quartic.impl&__2.dual._definition
)))

;; Function-Def curve25519_dalek::lizard::jacobi_quartic::JacobiPoint::dual
;; curve25519-dalek/src/lizard/jacobi_quartic.rs:334:5: 334:54 (#0)
(get-info :all-statistics)
(push)
 (declare-const result! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 (declare-const self! curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 (declare-const tmp%1 curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 (declare-const tmp%2 curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 (declare-const tmp%3 curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 (declare-const tmp%4 curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 (declare-const tmp%5 curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!) TYPE%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.)
 )
 (assert
  (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
      (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
    ))
   ) (I 54)
 ))
 (assert
  (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
      (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
    ))
   ) (I 54)
 ))
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%3 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%4 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%5 Bool)
 (assert
  (not (=>
    (= tmp%2 (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
       (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
    )))
    (and
     (=>
      %%location_label%%0
      (req%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element. tmp%2)
     )
     (=>
      (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element. tmp%2
       tmp%1
      )
      (=>
       (= tmp%5 tmp%1)
       (=>
        (= tmp%4 (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
           (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. self!)
        )))
        (and
         (=>
          %%location_label%%1
          (req%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element. tmp%4)
         )
         (=>
          (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.negate_field_element. tmp%4
           tmp%3
          )
          (=>
           (= result! (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. tmp%5)
             ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               tmp%3
           ))))
           (and
            (=>
             %%location_label%%2
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                 (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
               ))
              ) (I 52)
            ))
            (and
             (=>
              %%location_label%%3
              (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                  (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
                ))
               ) (I 52)
             ))
             (and
              (=>
               %%location_label%%4
               (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                    (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
                 )))
                ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
                   (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/S
                     (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                       self!
              )))))))))
              (=>
               %%location_label%%5
               (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                    (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. result!)
                 )))
                ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
                   (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!lizard.jacobi_quartic.JacobiPoint./JacobiPoint/T
                     (%Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint. (Poly%curve25519_dalek!lizard.jacobi_quartic.JacobiPoint.
                       self!
 ))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
