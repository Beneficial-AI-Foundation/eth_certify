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

;; MODULE 'module lemmas::common_lemmas::to_nat_lemmas'
;; curve25519-dalek/src/lemmas/common_lemmas/to_nat_lemmas.rs:837:1: 837:74 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_basic_div. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_upper_bound. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.impl&%0.skip. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_index. FuelId)
(declare-const fuel%vstd!seq.lemma_seq_two_subranges_index. FuelId)
(declare-const fuel%vstd!seq_lib.impl&%0.map. FuelId)
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
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.word64_from_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_basic_div. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.
  fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic.
  fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown. fuel%vstd!arithmetic.mul.lemma_mul_is_associative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. fuel%vstd!arithmetic.mul.lemma_mul_upper_bound.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.impl&%0.skip. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_subrange_decreases. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!seq.axiom_seq_subrange_len.
  fuel%vstd!seq.axiom_seq_subrange_index. fuel%vstd!seq.lemma_seq_two_subranges_index.
  fuel%vstd!seq_lib.impl&%0.map. fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len.
  fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view. fuel%vstd!view.impl&%14.view.
  fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.
  fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix. fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.
  fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat. fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.
  fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen. fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64.
  fuel%curve25519_dalek!specs.core_specs.word64_from_bytes. fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.
  fuel%vstd!array.group_array_axioms. fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp.
  fuel%vstd!laws_eq.bool_laws.group_laws_eq. fuel%vstd!laws_eq.u8_laws.group_laws_eq.
  fuel%vstd!laws_eq.i8_laws.group_laws_eq. fuel%vstd!laws_eq.u16_laws.group_laws_eq.
  fuel%vstd!laws_eq.i16_laws.group_laws_eq. fuel%vstd!laws_eq.u32_laws.group_laws_eq.
  fuel%vstd!laws_eq.i32_laws.group_laws_eq. fuel%vstd!laws_eq.u64_laws.group_laws_eq.
  fuel%vstd!laws_eq.i64_laws.group_laws_eq. fuel%vstd!laws_eq.u128_laws.group_laws_eq.
  fuel%vstd!laws_eq.i128_laws.group_laws_eq. fuel%vstd!laws_eq.usize_laws.group_laws_eq.
  fuel%vstd!laws_eq.isize_laws.group_laws_eq. fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms.
  fuel%vstd!map.group_map_axioms. fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
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
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_as_slice.)
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
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

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)

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
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<nat.>. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort vstd!seq.Seq<u64.>. 0)
(declare-sort slice%<u64.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (tuple%0. 0)) (((vstd!raw_ptr.PtrData./PtrData
    (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((tuple%0./tuple%0))
))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%fun%2. (Dcr Type Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%fun%2. (%%Function%%) Poly)
(declare-fun %Poly%fun%2. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<nat.>. (vstd!seq.Seq<nat.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<nat.>. (Poly) vstd!seq.Seq<nat.>.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%vstd!seq.Seq<u64.>. (vstd!seq.Seq<u64.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u64.>. (Poly) vstd!seq.Seq<u64.>.)
(declare-fun Poly%slice%<u64.>. (slice%<u64.>.) Poly)
(declare-fun %Poly%slice%<u64.>. (Poly) slice%<u64.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
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
   (= x (%Poly%fun%2. (Poly%fun%2. x)))
   :pattern ((Poly%fun%2. x))
   :qid internal_crate__fun__2_box_axiom_definition
   :skolemid skolem_internal_crate__fun__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (= x (Poly%fun%2. (%Poly%fun%2. x)))
   )
   :pattern ((has_type x (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&)))
   :qid internal_crate__fun__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__2_unbox_axiom_definition
)))
(declare-fun %%apply%%1 (%%Function%% Poly Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    %%Function%%
   )
  ) (!
   (=>
    (forall ((T%0 Poly) (T%1 Poly)) (!
      (=>
       (and
        (has_type T%0 T%0&)
        (has_type T%1 T%1&)
       )
       (has_type (%%apply%%1 x T%0 T%1) T%2&)
      )
      :pattern ((has_type (%%apply%%1 x T%0 T%1) T%2&))
      :qid internal_crate__fun__2_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__2_constructor_inner_definition
    ))
    (has_type (Poly%fun%2. (mk_fun x)) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
   )
   :pattern ((has_type (Poly%fun%2. (mk_fun x)) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&.
      T%2&
   )))
   :qid internal_crate__fun__2_constructor_definition
   :skolemid skolem_internal_crate__fun__2_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%0
    Poly
   ) (T%1 Poly) (x %%Function%%)
  ) (!
   (=>
    (and
     (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type T%0 T%0&)
     (has_type T%1 T%1&)
    )
    (has_type (%%apply%%1 x T%0 T%1) T%2&)
   )
   :pattern ((%%apply%%1 x T%0 T%1) (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&. T%0& T%1&.
      T%1& T%2&. T%2&
   )))
   :qid internal_crate__fun__2_apply_definition
   :skolemid skolem_internal_crate__fun__2_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%0
    Poly
   ) (T%1 Poly) (x %%Function%%)
  ) (!
   (=>
    (and
     (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type T%0 T%0&)
     (has_type T%1 T%1&)
    )
    (height_lt (height (%%apply%%1 x T%0 T%1)) (height (fun_from_recursive_field (Poly%fun%2.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%1 x T%0 T%1)) (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&.
      T%0& T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_crate__fun__2_height_apply_definition
   :skolemid skolem_internal_crate__fun__2_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (deep
    Bool
   ) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type y (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (forall ((T%0 Poly) (T%1 Poly)) (!
       (=>
        (and
         (has_type T%0 T%0&)
         (has_type T%1 T%1&)
        )
        (ext_eq deep T%2& (%%apply%%1 (%Poly%fun%2. x) T%0 T%1) (%%apply%%1 (%Poly%fun%2. y)
          T%0 T%1
       )))
       :pattern ((ext_eq deep T%2& (%%apply%%1 (%Poly%fun%2. x) T%0 T%1) (%%apply%%1 (%Poly%fun%2.
           y
          ) T%0 T%1
       )))
       :qid internal_crate__fun__2_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__2_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y))
   :qid internal_crate__fun__2_ext_equal_definition
   :skolemid skolem_internal_crate__fun__2_ext_equal_definition
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
 (forall ((x vstd!seq.Seq<nat.>.)) (!
   (= x (%Poly%vstd!seq.Seq<nat.>. (Poly%vstd!seq.Seq<nat.>. x)))
   :pattern ((Poly%vstd!seq.Seq<nat.>. x))
   :qid internal_vstd__seq__Seq<nat.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<nat.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ NAT))
    (= x (Poly%vstd!seq.Seq<nat.>. (%Poly%vstd!seq.Seq<nat.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ NAT)))
   :qid internal_vstd__seq__Seq<nat.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<nat.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<nat.>.)) (!
   (has_type (Poly%vstd!seq.Seq<nat.>. x) (TYPE%vstd!seq.Seq. $ NAT))
   :pattern ((has_type (Poly%vstd!seq.Seq<nat.>. x) (TYPE%vstd!seq.Seq. $ NAT)))
   :qid internal_vstd__seq__Seq<nat.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<nat.>_has_type_always_definition
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
 (forall ((x vstd!seq.Seq<u64.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u64.>. (Poly%vstd!seq.Seq<u64.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u64.>. x))
   :qid internal_vstd__seq__Seq<u64.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u64.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 64)))
    (= x (Poly%vstd!seq.Seq<u64.>. (%Poly%vstd!seq.Seq<u64.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 64))))
   :qid internal_vstd__seq__Seq<u64.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u64.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u64.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u64.>. x) (TYPE%vstd!seq.Seq. $ (UINT 64)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u64.>. x) (TYPE%vstd!seq.Seq. $ (UINT 64))))
   :qid internal_vstd__seq__Seq<u64.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u64.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<u64.>.)) (!
   (= x (%Poly%slice%<u64.>. (Poly%slice%<u64.>. x)))
   :pattern ((Poly%slice%<u64.>. x))
   :qid internal_crate__slice__<u64.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u64.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 64)))
    (= x (Poly%slice%<u64.>. (%Poly%slice%<u64.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 64))))
   :qid internal_crate__slice__<u64.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u64.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u64.>.)) (!
   (has_type (Poly%slice%<u64.>. x) (SLICE $ (UINT 64)))
   :pattern ((has_type (Poly%slice%<u64.>. x) (SLICE $ (UINT 64))))
   :qid internal_crate__slice__<u64.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u64.>_has_type_always_definition
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
(declare-fun array_new (Dcr Type Int %%Function%%) Poly)
(declare-fun array_index (Dcr Type Dcr Type %%Function%% Poly) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (= (array_new Tdcr T N Fn) (Poly%array%. Fn))
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_array_new
   :skolemid skolem_prelude_array_new
)))
(declare-fun %%apply%%2 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%2 Fn i) T)
      )
      :pattern ((has_type (%%apply%%2 Fn i) T))
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
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%2 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%2 Fn i))
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
 (= (proj%%vstd!view.View./V $ (UINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 32)) (UINT 32))
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

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::subrange
(declare-fun vstd!seq.Seq.subrange.? (Dcr Type Poly Poly Poly) Poly)

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

;; Function-Decl vstd::array::spec_array_as_slice
(declare-fun vstd!array.spec_array_as_slice.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl vstd::seq::impl&%0::skip
(declare-fun vstd!seq.impl&%0.skip.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq_lib::impl&%0::map
(declare-fun vstd!seq_lib.impl&%0.map.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_suffix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? (Dcr Type Poly
  Poly
 ) Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? (Dcr Type
  Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat_rec
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? (Poly Poly Fuel)
 Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_seq_as_nat
(declare-fun curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? (Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? (Poly Fuel)
 Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::words_as_nat_gen
(declare-fun curve25519_dalek!specs.core_specs.words_as_nat_gen.? (Poly Poly Poly)
 Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? (Poly Poly Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::words_as_nat_u64
(declare-fun curve25519_dalek!specs.core_specs.words_as_nat_u64.? (Poly Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::word64_from_bytes
(declare-fun curve25519_dalek!specs.core_specs.word64_from_bytes.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::words64_from_bytes_to_nat
(declare-fun curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? (Poly Poly)
 Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? (Poly
  Poly Fuel
 ) Int
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
    :qid user_vstd__seq__axiom_seq_new_len_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_2
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
    :qid user_vstd__seq__axiom_seq_new_index_3
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_3
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
          :qid user_vstd__seq__axiom_seq_ext_equal_4
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_4
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_5
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_5
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_6
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_6
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_7
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_7
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
    :qid user_vstd__seq__axiom_seq_subrange_len_8
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_8
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
    :qid user_vstd__seq__axiom_seq_subrange_index_9
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_9
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
    :qid user_vstd__seq__lemma_seq_two_subranges_index_10
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_10
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
    :qid user_vstd__slice__axiom_spec_len_11
    :skolemid skolem_user_vstd__slice__axiom_spec_len_11
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
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
          :qid user_vstd__slice__axiom_slice_ext_equal_12
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_12
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_13
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_13
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
    :qid user_vstd__slice__axiom_slice_has_resolved_14
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_14
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
    :qid user_vstd__array__array_len_matches_n_15
    :skolemid skolem_user_vstd__array__array_len_matches_n_15
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%4
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
    :qid user_vstd__array__lemma_array_index_16
    :skolemid skolem_user_vstd__array__lemma_array_index_16
))))

;; Function-Axioms vstd::array::spec_array_as_slice
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
   (=>
    (has_type ar! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!) (SLICE T&. T&))
   )
   :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
   :qid internal_vstd!array.spec_array_as_slice.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_as_slice.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_as_slice
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_as_slice.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!view.View.view.? $slice (SLICE T&. T&) (vstd!array.spec_array_as_slice.? T&.
         T& N&. N& ar!
        )
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!)
    )))
    :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
    :qid user_vstd__array__axiom_spec_array_as_slice_17
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_17
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
         :qid user_vstd__array__axiom_array_ext_equal_18
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_18
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_19
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_19
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
    :qid user_vstd__array__axiom_array_has_resolved_20
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_20
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_21
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_21
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_22
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_22
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_basic_div
(declare-fun req%vstd!arithmetic.div_mod.lemma_basic_div. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_basic_div. x! d!) (=>
     %%global_location_label%%5
     (let
      ((tmp%%$ x!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ d!)
   ))))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_basic_div. x! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_basic_div._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_basic_div._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_basic_div. (Int Int) Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_basic_div. x! d!) (= (EucDiv x! d!) 0))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_basic_div. x! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_basic_div._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_basic_div._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_basic_div
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_basic_div.)
  (forall ((x! Int) (d! Int)) (!
    (=>
     (let
      ((tmp%%$ x!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ d!)
     ))
     (= (EucDiv x! d!) 0)
    )
    :pattern ((EucDiv x! d!))
    :qid user_vstd__arithmetic__div_mod__lemma_basic_div_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_basic_div_23
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%6
      (< x! m!)
     )
     (=>
      %%global_location_label%%7
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%8
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
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_24
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_24
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_multiples_vanish_fancy
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. (Int Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (b! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!) (and
     (=>
      %%global_location_label%%9
      (< 0 d!)
     )
     (=>
      %%global_location_label%%10
      (let
       ((tmp%%$ b!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
   )))))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. (Int Int
  Int
 ) Bool
)
(assert
 (forall ((x! Int) (b! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!) (= (EucDiv
      (Add (Mul d! x!) b!) d!
     ) x!
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_multiples_vanish_fancy
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy.)
  (forall ((x! Int) (b! Int) (d! Int)) (!
    (=>
     (and
      (< 0 d!)
      (let
       ((tmp%%$ b!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
     )))
     (= (EucDiv (Add (Mul d! x!) b!) d!) x!)
    )
    :pattern ((EucDiv (Add (Mul d! x!) b!) d!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_fancy_25
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_fancy_25
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (=>
     %%global_location_label%%11
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (= (EucMod (Mul x!
       m!
      ) m!
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod (Mul x! m!) m!) 0)
    )
    :pattern ((EucMod (Mul x! m!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_26
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_26
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_breakdown
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_breakdown. (Int Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!) (and
     (=>
      %%global_location_label%%12
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%13
      (< 0 y!)
     )
     (=>
      %%global_location_label%%14
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_breakdown_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_breakdown_27
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_28
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_28
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_29
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_29
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_upper_bound
(declare-fun req%vstd!arithmetic.mul.lemma_mul_upper_bound. (Int Int Int Int) Bool)
(declare-const %%global_location_label%%15 Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((x! Int) (xbound! Int) (y! Int) (ybound! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_upper_bound. x! xbound! y! ybound!) (and
     (=>
      %%global_location_label%%15
      (<= x! xbound!)
     )
     (=>
      %%global_location_label%%16
      (<= y! ybound!)
     )
     (=>
      %%global_location_label%%17
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%18
      (<= 0 y!)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_upper_bound. x! xbound! y! ybound!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_upper_bound._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_upper_bound._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_upper_bound. (Int Int Int Int) Bool)
(assert
 (forall ((x! Int) (xbound! Int) (y! Int) (ybound! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_upper_bound. x! xbound! y! ybound!) (<= (Mul x!
      y!
     ) (Mul xbound! ybound!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_upper_bound. x! xbound! y! ybound!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_upper_bound._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_upper_bound._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_upper_bound
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_upper_bound.)
  (forall ((x! Int) (xbound! Int) (y! Int) (ybound! Int)) (!
    (=>
     (and
      (and
       (and
        (<= x! xbound!)
        (<= y! ybound!)
       )
       (<= 0 x!)
      )
      (<= 0 y!)
     )
     (<= (Mul x! y!) (Mul xbound! ybound!))
    )
    :pattern ((Mul x! y!) (Mul xbound! ybound!))
    :qid user_vstd__arithmetic__mul__lemma_mul_upper_bound_30
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_upper_bound_30
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_31
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_31
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_32
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_32
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_33
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_33
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_34
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_34
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

;; Function-Axioms curve25519_dalek::specs::core_specs::u8_32_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!) (nClip (Add (nClip (Add (
          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                                                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.?
                                                                       $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) bytes!) (
                                                                        I 0
                                                                      ))
                                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8))))
                                                                    )
                                                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                          8
                                                                         ) $ (CONST_INT 32)
                                                                        ) bytes!
                                                                       ) (I 1)
                                                                      )
                                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8))))
                                                                  )))
                                                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                        8
                                                                       ) $ (CONST_INT 32)
                                                                      ) bytes!
                                                                     ) (I 2)
                                                                    )
                                                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8))))
                                                                )))
                                                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                      8
                                                                     ) $ (CONST_INT 32)
                                                                    ) bytes!
                                                                   ) (I 3)
                                                                  )
                                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8))))
                                                              )))
                                                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                    8
                                                                   ) $ (CONST_INT 32)
                                                                  ) bytes!
                                                                 ) (I 4)
                                                                )
                                                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8))))
                                                            )))
                                                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                  8
                                                                 ) $ (CONST_INT 32)
                                                                ) bytes!
                                                               ) (I 5)
                                                              )
                                                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8))))
                                                          )))
                                                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                8
                                                               ) $ (CONST_INT 32)
                                                              ) bytes!
                                                             ) (I 6)
                                                            )
                                                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8))))
                                                        )))
                                                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                              8
                                                             ) $ (CONST_INT 32)
                                                            ) bytes!
                                                           ) (I 7)
                                                          )
                                                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8))))
                                                      )))
                                                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                            8
                                                           ) $ (CONST_INT 32)
                                                          ) bytes!
                                                         ) (I 8)
                                                        )
                                                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 8 8))))
                                                    )))
                                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                          8
                                                         ) $ (CONST_INT 32)
                                                        ) bytes!
                                                       ) (I 9)
                                                      )
                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 9 8))))
                                                  )))
                                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                        8
                                                       ) $ (CONST_INT 32)
                                                      ) bytes!
                                                     ) (I 10)
                                                    )
                                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 10 8))))
                                                )))
                                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                      8
                                                     ) $ (CONST_INT 32)
                                                    ) bytes!
                                                   ) (I 11)
                                                  )
                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 11 8))))
                                              )))
                                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                    8
                                                   ) $ (CONST_INT 32)
                                                  ) bytes!
                                                 ) (I 12)
                                                )
                                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 12 8))))
                                            )))
                                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                  8
                                                 ) $ (CONST_INT 32)
                                                ) bytes!
                                               ) (I 13)
                                              )
                                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 13 8))))
                                          )))
                                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                8
                                               ) $ (CONST_INT 32)
                                              ) bytes!
                                             ) (I 14)
                                            )
                                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 14 8))))
                                        )))
                                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                              8
                                             ) $ (CONST_INT 32)
                                            ) bytes!
                                           ) (I 15)
                                          )
                                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 15 8))))
                                      )))
                                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                            8
                                           ) $ (CONST_INT 32)
                                          ) bytes!
                                         ) (I 16)
                                        )
                                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 16 8))))
                                    )))
                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                          8
                                         ) $ (CONST_INT 32)
                                        ) bytes!
                                       ) (I 17)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 17 8))))
                                  )))
                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                        8
                                       ) $ (CONST_INT 32)
                                      ) bytes!
                                     ) (I 18)
                                    )
                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 18 8))))
                                )))
                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                      8
                                     ) $ (CONST_INT 32)
                                    ) bytes!
                                   ) (I 19)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 19 8))))
                              )))
                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                    8
                                   ) $ (CONST_INT 32)
                                  ) bytes!
                                 ) (I 20)
                                )
                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 20 8))))
                            )))
                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                  8
                                 ) $ (CONST_INT 32)
                                ) bytes!
                               ) (I 21)
                              )
                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 21 8))))
                          )))
                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                8
                               ) $ (CONST_INT 32)
                              ) bytes!
                             ) (I 22)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 22 8))))
                        )))
                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                              8
                             ) $ (CONST_INT 32)
                            ) bytes!
                           ) (I 23)
                          )
                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 23 8))))
                      )))
                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                            8
                           ) $ (CONST_INT 32)
                          ) bytes!
                         ) (I 24)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 24 8))))
                    )))
                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                          8
                         ) $ (CONST_INT 32)
                        ) bytes!
                       ) (I 25)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 25 8))))
                  )))
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                        8
                       ) $ (CONST_INT 32)
                      ) bytes!
                     ) (I 26)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 26 8))))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                      8
                     ) $ (CONST_INT 32)
                    ) bytes!
                   ) (I 27)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 27 8))))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                    8
                   ) $ (CONST_INT 32)
                  ) bytes!
                 ) (I 28)
                )
               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 28 8))))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                  8
                 ) $ (CONST_INT 32)
                ) bytes!
               ) (I 29)
              )
             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 29 8))))
          )))
         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                8
               ) $ (CONST_INT 32)
              ) bytes!
             ) (I 30)
            )
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 30 8))))
        )))
       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
              8
             ) $ (CONST_INT 32)
            ) bytes!
           ) (I 31)
          )
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 31 8))))
    )))))
    :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
    :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (= (req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!) (=>
     %%global_location_label%%19
     (<= (%I j!) (vstd!seq.Seq.len.? $ (UINT 8) bytes!))
   ))
   :pattern ((req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!))
   :qid internal_req__curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. Fuel)
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%) (
     curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! (succ fuel%))
     (ite
      (= (%I j!) 0)
      0
      (let
       ((j1$ (nClip (Sub (%I j!) 1))))
       (nClip (Add (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! (I j1$)
          fuel%
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j1$ 8)))) (%I (vstd!seq.Seq.index.?
             $ (UINT 8) bytes! (I j1$)
   ))))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! (succ
      fuel%
   )))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
  (forall ((bytes! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
      (has_type j! NAT)
     )
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.?
       bytes! j! (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_definition
))))
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_prefix.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_prefix.?_pre_post_rec_definition
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

;; Function-Axioms vstd::seq_lib::impl&%0::map
(assert
 (fuel_bool_default fuel%vstd!seq_lib.impl&%0.map.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 %%Function%%)
   (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$) (%%apply%%1
     %%hole%%3 i$ (vstd!seq.Seq.index.? %%hole%%0 %%hole%%1 %%hole%%2 i$)
   ))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$))
)))
(assert
 (=>
  (fuel_bool fuel%vstd!seq_lib.impl&%0.map.)
  (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type) (self! Poly) (f! Poly)) (!
    (= (vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!) (vstd!seq.Seq.new.? B&. B& $
      (TYPE%fun%1. $ INT B&. B&) (I (vstd!seq.Seq.len.? A&. A& self!)) (Poly%fun%1. (mk_fun
        (%%lambda%%1 A&. A& self! (%Poly%fun%2. f!))
    ))))
    :pattern ((vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!))
    :qid internal_vstd!seq_lib.impl&__0.map.?_definition
    :skolemid skolem_internal_vstd!seq_lib.impl&__0.map.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type) (self! Poly) (f! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type f! (TYPE%fun%2. $ INT A&. A& B&. B&))
    )
    (has_type (vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!) (TYPE%vstd!seq.Seq. B&.
      B&
   )))
   :pattern ((vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!))
   :qid internal_vstd!seq_lib.impl&__0.map.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq_lib.impl&__0.map.?_pre_post_definition
)))

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

;; Function-Axioms vstd::view::impl&%20::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%20.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%20.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 32) self!))
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

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_as_nat_suffix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix. Fuel)
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
     fuel%
    ) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
     zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes!
     start! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_zero_definition
)))
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (uInv SZ (const_int N&))
     (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
     (has_type start! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
      (succ fuel%)
     ) (ite
      (>= (%I start!) (const_int N&))
      0
      (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 8) N&. N&
             ) bytes!
            ) start!
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I start!) 8))))
         )
        ) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! (I (Add
           (%I start!) 1
          )
         ) fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes!
     start! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.)
  (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly)) (!
    (=>
     (and
      (uInv SZ (const_int N&))
      (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
      (has_type start! INT)
     )
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!)
      (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
       (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_definition
))))
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
     (has_type start! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_pre_post_definition
)))
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
     (has_type start! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
      fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes!
     start! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_suffix.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_suffix.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::u8_32_as_nat_rec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec. Fuel)
(assert
 (forall ((bytes! Poly) (index! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%)
    (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! zero)
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (index! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (has_type index! NAT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! (succ fuel%))
     (ite
      (>= (%I index!) 32)
      0
      (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 8) $ (CONST_INT 32)
             ) bytes!
            ) index!
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I index!) 8))))
         )
        ) (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! (I (nClip (Add (%I
             index!
            ) 1
          ))
         ) fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! (
      succ fuel%
   )))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.)
  (forall ((bytes! Poly) (index! Poly)) (!
    (=>
     (and
      (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
      (has_type index! NAT)
     )
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!) (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.?
       bytes! index! (succ fuel_nat%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!))
    :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_definition
))))
(assert
 (forall ((bytes! Poly) (index! Poly)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (has_type index! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (index! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (has_type index! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__u8_32_as_nat_rec.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__u8_32_as_nat_rec.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_seq_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_seq_as_nat. Fuel)
(assert
 (forall ((bytes! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%) (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.?
     bytes! zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (fuel% Fuel)) (!
   (=>
    (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (= (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! (succ fuel%))
     (ite
      (= (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 0)
      0
      (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I 0))) (nClip (Mul (vstd!arithmetic.power2.pow2.?
           (I 8)
          ) (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 8) bytes! (I 1) (I (vstd!seq.Seq.len.? $ (UINT 8) bytes!))
           ) fuel%
   ))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! (succ fuel%)))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.)
  (forall ((bytes! Poly)) (!
    (=>
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (= (curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!) (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.?
       bytes! (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (fuel% Fuel)) (!
   (=>
    (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_seq_as_nat.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_seq_as_nat.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::words_as_nat_gen
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.words_as_nat_gen. Fuel)
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
     fuel%
    ) (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
     zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words!
     bits_per_word! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_zero_definition
)))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
      (succ fuel%)
     ) (ite
      (<= (%I num_words!) 0)
      0
      (let
       ((word_value$ (nClip (Mul (%I (vstd!seq.Seq.index.? $ NAT words! (I (Sub (%I num_words!)
               1
            )))
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (Sub (%I num_words!) 1) (%I bits_per_word!)))))
       ))))
       (nClip (Add word_value$ (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words!
          (I (Sub (%I num_words!) 1)) bits_per_word! fuel%
   )))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words!
     bits_per_word! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
  (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
    (=>
     (and
      (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
      (has_type num_words! INT)
      (has_type bits_per_word! INT)
     )
     (= (curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!)
      (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
       (succ fuel_nat%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!))
    :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_definition
))))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
   (=>
    (and
     (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_pre_post_definition
)))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
      fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words!
     bits_per_word! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__words_as_nat_gen.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__words_as_nat_gen.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::words_as_nat_u64
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64.)
)
(declare-fun %%lambda%%2 () %%Function%%)
(assert
 (forall ((i$ Poly) (x$ Poly)) (!
   (= (%%apply%%1 %%lambda%%2 i$ x$) x$)
   :pattern ((%%apply%%1 %%lambda%%2 i$ x$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64.)
  (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!)
     (curve25519_dalek!specs.core_specs.words_as_nat_gen.? (vstd!seq_lib.impl&%0.map.? $
       (UINT 64) $ NAT (vstd!view.View.view.? $slice (SLICE $ (UINT 64)) words!) (Poly%fun%2.
        (mk_fun %%lambda%%2)
       )
      ) num_words! bits_per_word!
    ))
    :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!))
    :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_definition
))))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
   (=>
    (and
     (has_type words! (SLICE $ (UINT 64)))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::word64_from_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.word64_from_bytes.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.word64_from_bytes.)
  (forall ((bytes! Poly) (word_idx! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!) (let
      ((num_words$ (EucDiv (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 8)))
      (ite
       (not (and
         (<= 0 (%I word_idx!))
         (< (%I word_idx!) num_words$)
       ))
       0
       (let
        ((base$ (Mul (%I word_idx!) 8)))
        (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul (
                         %I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 0)))
                        ) (vstd!arithmetic.power2.pow2.? (I 0))
                       )
                      ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 1)))) (vstd!arithmetic.power2.pow2.?
                         (I 8)
                     ))))
                    ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 2)))) (vstd!arithmetic.power2.pow2.?
                       (I 16)
                   ))))
                  ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 3)))) (vstd!arithmetic.power2.pow2.?
                     (I 24)
                 ))))
                ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 4)))) (vstd!arithmetic.power2.pow2.?
                   (I 32)
               ))))
              ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 5)))) (vstd!arithmetic.power2.pow2.?
                 (I 40)
             ))))
            ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 6)))) (vstd!arithmetic.power2.pow2.?
               (I 48)
           ))))
          ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 7)))) (vstd!arithmetic.power2.pow2.?
             (I 56)
    )))))))))
    :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!))
    :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_definition
))))
(assert
 (forall ((bytes! Poly) (word_idx! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type word_idx! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!))
   :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::words64_from_bytes_to_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.
 Fuel
)
(assert
 (forall ((bytes! Poly) (count! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
     fuel%
    ) (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
     zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
     count! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (count! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type count! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
      (succ fuel%)
     ) (let
      ((num_words$ (EucDiv (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 8)))
      (ite
       (<= (%I count!) 0)
       0
       (ite
        (> (%I count!) num_words$)
        (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! (I num_words$)
         fuel%
        )
        (let
         ((idx$ (Sub (%I count!) 1)))
         (nClip (Add (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
            (I idx$) fuel%
           ) (nClip (Mul (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! (I idx$))
             (vstd!arithmetic.power2.pow2.? (I (nClip (Mul idx$ 64))))
   ))))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
     count! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.)
  (forall ((bytes! Poly) (count! Poly)) (!
    (=>
     (and
      (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
      (has_type count! INT)
     )
     (= (curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!) (
       curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count! (
        succ fuel_nat%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.
    ))))
    :pattern ((curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!))
    :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_definition
))))
(assert
 (forall ((bytes! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type count! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!))
   :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (count! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type count! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
      fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
     count! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__words64_from_bytes_to_nat.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__words64_from_bytes_to_nat.?_pre_post_rec_definition
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
 (tr_bound%vstd!view.View. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_div_mod
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod. x! k!
     s!
    ) (= (EucMod (EucDiv x! (vstd!arithmetic.power2.pow2.? (I k!))) (vstd!arithmetic.power2.pow2.?
       (I s!)
      )
     ) (EucDiv (EucMod x! (vstd!arithmetic.power2.pow2.? (I (nClip (Add s! k!))))) (vstd!arithmetic.power2.pow2.?
       (I k!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod.
     x! k! s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_equals_rec
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec.
     bytes!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?
      (Poly%array%. bytes!) (I 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_rec_bound
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound.
 (%%Function%% Int Int) Bool
)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((bytes! %%Function%%) (start! Int) (target! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound.
     bytes! start! target!
    ) (=>
     %%global_location_label%%20
     (let
      ((tmp%%$ target!))
      (and
       (<= start! tmp%%$)
       (< tmp%%$ 32)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound.
     bytes! start! target!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound.
 (%%Function%% Int Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (start! Int) (target! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound.
     bytes! start! target!
    ) (>= (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!) (
       I start!
      )
     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
            8
           ) $ (CONST_INT 32)
          ) (Poly%array%. bytes!)
         ) (I target!)
        )
       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul target! 8))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound.
     bytes! start! target!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_rec_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_lower_bound
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((bytes! %%Function%%) (index! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
    ) (=>
     %%global_location_label%%21
     (< index! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (index! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
    ) (>= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (nClip
      (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
           (CONST_INT 32)
          ) (Poly%array%. bytes!)
         ) (I index!)
        )
       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul index! 8))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_decomposition_prefix_rec
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
    ) (=>
     %%global_location_label%%22
     (<= n! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!) (I
       0
      )
     ) (nClip (Add (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
         $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
        ) (I n!)
       ) (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!) (I n!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_suffix_zero_when_bytes_zero
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero.
     bytes! n!
    ) (and
     (=>
      %%global_location_label%%23
      (<= n! 32)
     )
     (=>
      %%global_location_label%%24
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= n! tmp%%$)
            (< tmp%%$ 32)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                CONST_INT 32
               )
              ) (Poly%array%. bytes!)
             ) i$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_suffix_zero_when_bytes_zero_38
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_suffix_zero_when_bytes_zero_38
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero.
     bytes! n!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!) (I
       n!
      )
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_suffix_zero_when_bytes_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_with_trailing_zeros
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros.
     bytes! n!
    ) (and
     (=>
      %%global_location_label%%25
      (<= n! 32)
     )
     (=>
      %%global_location_label%%26
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= n! tmp%%$)
            (< tmp%%$ 32)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                CONST_INT 32
               )
              ) (Poly%array%. bytes!)
             ) i$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u8_32_as_nat_with_trailing_zeros_43
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u8_32_as_nat_with_trailing_zeros_43
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros.
     bytes! n!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?
      (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!))
      (I n!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_with_trailing_zeros._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_first_byte_only
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only.
     bytes!
    ) (=>
     %%global_location_label%%27
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 1 tmp%%$)
           (< tmp%%$ 32)
         ))
         (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
               CONST_INT 32
              )
             ) (Poly%array%. bytes!)
            ) i$
           )
          ) 0
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 32)
          ) (Poly%array%. bytes!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u8_32_as_nat_first_byte_only_49
       :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u8_32_as_nat_first_byte_only_49
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only.
     bytes!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only.
     bytes!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (%I (
       vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
          32
         )
        ) (Poly%array%. bytes!)
       ) (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_first_byte_only._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_prefix_equal_when_bytes_match
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match.
 (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>. Int) Bool
)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((seq1! vstd!seq.Seq<u8.>.) (seq2! vstd!seq.Seq<u8.>.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match.
     seq1! seq2! n!
    ) (and
     (=>
      %%global_location_label%%28
      (>= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq1!)) n!)
     )
     (=>
      %%global_location_label%%29
      (>= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq2!)) n!)
     )
     (=>
      %%global_location_label%%30
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq1!) i$) (vstd!seq.Seq.index.?
            $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq2!) i$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq1!) i$))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq2!) i$))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_prefix_equal_when_bytes_match_52
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_prefix_equal_when_bytes_match_52
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match.
     seq1! seq2! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match.
 (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>. Int) Bool
)
(assert
 (forall ((seq1! vstd!seq.Seq<u8.>.) (seq2! vstd!seq.Seq<u8.>.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match.
     seq1! seq2! n!
    ) (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       seq1!
      ) (I n!)
     ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       seq2!
      ) (I n!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match.
     seq1! seq2! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equal_when_bytes_match._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_from_le_bytes
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes.
 (vstd!seq.Seq<u8.>. %%Function%% Int) Bool
)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(assert
 (forall ((le_seq! vstd!seq.Seq<u8.>.) (bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes. le_seq!
     bytes! n!
    ) (and
     (=>
      %%global_location_label%%31
      (<= n! 32)
     )
     (=>
      %%global_location_label%%32
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. le_seq!)) n!)
     )
     (=>
      %%global_location_label%%33
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. le_seq!) i$) (vstd!seq.Seq.index.?
            $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
              bytes!
             )
            ) i$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. le_seq!) i$))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_from_le_bytes_56
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_from_le_bytes_56
     )))
     (=>
      %%global_location_label%%34
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= n! tmp%%$)
            (< tmp%%$ 32)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                CONST_INT 32
               )
              ) (Poly%array%. bytes!)
             ) i$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_from_le_bytes_57
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_from_le_bytes_57
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes.
     le_seq! bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes.
 (vstd!seq.Seq<u8.>. %%Function%% Int) Bool
)
(assert
 (forall ((le_seq! vstd!seq.Seq<u8.>.) (bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes. le_seq!
     bytes! n!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?
      (Poly%vstd!seq.Seq<u8.>. le_seq!) (I n!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes.
     le_seq! bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_from_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_lt_pow2_8
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8. x!) (
     < x! (vstd!arithmetic.power2.pow2.? (I 8))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_bytes_as_nat_prefix_bounded
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
 (vstd!seq.Seq<u8.>. Int) Bool
)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((bytes! vstd!seq.Seq<u8.>.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
    ) (=>
     %%global_location_label%%35
     (<= n! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
 (vstd!seq.Seq<u8.>. Int) Bool
)
(assert
 (forall ((bytes! vstd!seq.Seq<u8.>.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
    ) (< (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       bytes!
      ) (I n!)
     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul n! 8))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_sum_both_divisible
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((a! Int) (b! Int) (d! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
    ) (and
     (=>
      %%global_location_label%%36
      (> d! 0)
     )
     (=>
      %%global_location_label%%37
      (= (EucMod a! d!) 0)
     )
     (=>
      %%global_location_label%%38
      (= (EucMod b! d!) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (d! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
    ) (= (EucMod (nClip (Add a! b!)) d!) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_rec_suffix_divisible
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%39 Bool)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible.
     bytes! n!
    ) (=>
     %%global_location_label%%39
     (<= n! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible.
     bytes! n!
    ) (= (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!)
       (I n!)
      ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul n! 8))))
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_rec_suffix_divisible._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_sum_factor
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
    ) (=>
     %%global_location_label%%40
     (> m! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
    ) (= (EucMod (Add (Mul a! m!) b!) m!) (EucMod b! m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_mod_truncates
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates.
     bytes! n!
    ) (=>
     %%global_location_label%%41
     (<= n! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates.
     bytes! n!
    ) (= (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!))
      (vstd!arithmetic.power2.pow2.? (I (nClip (Mul n! 8))))
     ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.? $
       (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
      ) (I n!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_mod_truncates._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_prefix_div_extracts_byte
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((bytes! %%Function%%) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte.
     bytes! i!
    ) (=>
     %%global_location_label%%42
     (< i! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte.
     bytes! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte.
     bytes! i!
    ) (= (EucMod (EucDiv (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
         $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
        ) (I (nClip (Add i! 1)))
       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul i! 8))))
      ) (vstd!arithmetic.power2.pow2.? (I 8))
     ) (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
          CONST_INT 32
         )
        ) (Poly%array%. bytes!)
       ) (I i!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte.
     bytes! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_div_extracts_byte._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_extract_byte_at_index
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((bytes! %%Function%%) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index.
     bytes! i!
    ) (=>
     %%global_location_label%%43
     (< i! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index.
     bytes! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index.
     bytes! i!
    ) (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
         (CONST_INT 32)
        ) (Poly%array%. bytes!)
       ) (I i!)
      )
     ) (EucMod (EucDiv (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!))
       (vstd!arithmetic.power2.pow2.? (I (nClip (Mul i! 8))))
      ) (vstd!arithmetic.power2.pow2.? (I 8))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index.
     bytes! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_extract_byte_at_index._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_canonical_bytes_equal
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%44 Bool)
(assert
 (forall ((bytes1! %%Function%%) (bytes2! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
    ) (=>
     %%global_location_label%%44
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes1!)) (curve25519_dalek!specs.core_specs.u8_32_as_nat.?
       (Poly%array%. bytes2!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((bytes1! %%Function%%) (bytes2! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
    ) (forall ((i$ Poly)) (!
      (=>
       (has_type i$ INT)
       (=>
        (let
         ((tmp%%$ (%I i$)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ 32)
        ))
        (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
             32
            )
           ) (Poly%array%. bytes1!)
          ) i$
         ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
             32
            )
           ) (Poly%array%. bytes2!)
          ) i$
      ))))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
          $ (CONST_INT 32)
         ) (Poly%array%. bytes1!)
        ) i$
      ))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
          $ (CONST_INT 32)
         ) (Poly%array%. bytes2!)
        ) i$
      ))
      :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_canonical_bytes_equal_90
      :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_canonical_bytes_equal_90
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_lt_pow2_255
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%45 Bool)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
    ) (=>
     %%global_location_label%%45
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
          (CONST_INT 32)
         ) (Poly%array%. bytes!)
        ) (I 31)
       )
      ) 127
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
    ) (< (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (vstd!arithmetic.power2.pow2.?
      (I 255)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_identity
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity.
     bytes!
    ) (and
     (=>
      %%global_location_label%%46
      (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
            CONST_INT 32
           )
          ) (Poly%array%. bytes!)
         ) (I 0)
        )
       ) 1
     ))
     (=>
      %%global_location_label%%47
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 1 tmp%%$)
            (< tmp%%$ 32)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                CONST_INT 32
               )
              ) (Poly%array%. bytes!)
             ) i$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u8_32_as_nat_identity_96
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u8_32_as_nat_identity_96
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity.
     bytes!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity.
     bytes!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) 1)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_bytes_as_nat_prefix_chunk
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk.
 (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>. Int Int) Bool
)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(assert
 (forall ((bytes! vstd!seq.Seq<u8.>.) (chunk! vstd!seq.Seq<u8.>.) (k! Int) (remaining!
    Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk.
     bytes! chunk! k! remaining!
    ) (and
     (=>
      %%global_location_label%%48
      (<= remaining! 8)
     )
     (=>
      %%global_location_label%%49
      (>= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!)) (nClip (Add (nClip
          (Mul k! 8)
         ) 8
     ))))
     (=>
      %%global_location_label%%50
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. chunk!)) 8)
     )
     (=>
      %%global_location_label%%51
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. chunk!) j$) (vstd!seq.Seq.index.?
            $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!) (I (Add (nClip (Mul k! 8)) (%I j$)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. chunk!) j$))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_bytes_as_nat_prefix_chunk_100
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_bytes_as_nat_prefix_chunk_100
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk.
     bytes! chunk! k! remaining!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk.
 (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>. Int Int) Bool
)
(assert
 (forall ((bytes! vstd!seq.Seq<u8.>.) (chunk! vstd!seq.Seq<u8.>.) (k! Int) (remaining!
    Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk.
     bytes! chunk! k! remaining!
    ) (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       bytes!
      ) (I (nClip (Add (nClip (Mul k! 8)) remaining!)))
     ) (nClip (Add (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
         bytes!
        ) (I (nClip (Mul k! 8)))
       ) (nClip (Mul (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
           chunk!
          ) (I remaining!)
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul k! 64))))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk.
     bytes! chunk! k! remaining!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_chunk._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u64x4_from_le_bytes
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes.
 (%%Function%% %%Function%% %%Function%% %%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(assert
 (forall ((bytes! %%Function%%) (chunk0! %%Function%%) (chunk1! %%Function%%) (chunk2!
    %%Function%%
   ) (chunk3! %%Function%%)
  ) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes.
     bytes! chunk0! chunk1! chunk2! chunk3!
    ) (and
     (=>
      %%global_location_label%%52
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               8
              )
             ) (Poly%array%. chunk0!)
            ) j$
           ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               32
              )
             ) (Poly%array%. bytes!)
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 8)
           ) (Poly%array%. chunk0!)
          ) j$
        ))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_107
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_107
     )))
     (=>
      %%global_location_label%%53
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               8
              )
             ) (Poly%array%. chunk1!)
            ) j$
           ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               32
              )
             ) (Poly%array%. bytes!)
            ) (I (Add 8 (%I j$)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 8)
           ) (Poly%array%. chunk1!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_108
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_108
     )))
     (=>
      %%global_location_label%%54
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               8
              )
             ) (Poly%array%. chunk2!)
            ) j$
           ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               32
              )
             ) (Poly%array%. bytes!)
            ) (I (Add 16 (%I j$)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 8)
           ) (Poly%array%. chunk2!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_109
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_109
     )))
     (=>
      %%global_location_label%%55
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               8
              )
             ) (Poly%array%. chunk3!)
            ) j$
           ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
               32
              )
             ) (Poly%array%. bytes!)
            ) (I (Add 24 (%I j$)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 8)
           ) (Poly%array%. chunk3!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_110
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_u64x4_from_le_bytes_110
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes.
     bytes! chunk0! chunk1! chunk2! chunk3!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes.
 (%%Function%% %%Function%% %%Function%% %%Function%% %%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%) (chunk0! %%Function%%) (chunk1! %%Function%%) (chunk2!
    %%Function%%
   ) (chunk3! %%Function%%)
  ) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes.
     bytes! chunk0! chunk1! chunk2! chunk3!
    ) (= (nClip (Add (nClip (Add (nClip (Add (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?
            (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 8)) (Poly%array%. chunk0!))
            (I 8)
           ) (nClip (Mul (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
               $ (ARRAY $ (UINT 8) $ (CONST_INT 8)) (Poly%array%. chunk1!)
              ) (I 8)
             ) (vstd!arithmetic.power2.pow2.? (I 64))
          )))
         ) (nClip (Mul (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
             $ (ARRAY $ (UINT 8) $ (CONST_INT 8)) (Poly%array%. chunk2!)
            ) (I 8)
           ) (vstd!arithmetic.power2.pow2.? (I 128))
        )))
       ) (nClip (Mul (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
           $ (ARRAY $ (UINT 8) $ (CONST_INT 8)) (Poly%array%. chunk3!)
          ) (I 8)
         ) (vstd!arithmetic.power2.pow2.? (I 192))
      )))
     ) (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes.
     bytes! chunk0! chunk1! chunk2! chunk3!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u64x4_from_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_horner_to_prefix_step
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step.
 (vstd!seq.Seq<u8.>. Int) Bool
)
(declare-const %%global_location_label%%56 Bool)
(declare-const %%global_location_label%%57 Bool)
(assert
 (forall ((seq! vstd!seq.Seq<u8.>.) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step.
     seq! k!
    ) (and
     (=>
      %%global_location_label%%56
      (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq!)) 0)
     )
     (=>
      %%global_location_label%%57
      (<= k! (Sub (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq!)) 1))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step.
     seq! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step.
 (vstd!seq.Seq<u8.>. Int) Bool
)
(assert
 (forall ((seq! vstd!seq.Seq<u8.>.) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step.
     seq! k!
    ) (= (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
            seq!
           ) (I 0)
          )
         ) (vstd!arithmetic.power2.pow2.? (I 0))
        )
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 8)) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?
          (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq!) (I 1) (I (vstd!seq.Seq.len.?
             $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq!)
           ))
          ) (I k!)
      ))))
     ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       seq!
      ) (I (nClip (Add k! 1)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step.
     seq! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_horner_to_prefix_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_bytes_seq_as_nat_equals_prefix
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_seq_as_nat_equals_prefix.
 (vstd!seq.Seq<u8.>.) Bool
)
(assert
 (forall ((seq! vstd!seq.Seq<u8.>.)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_seq_as_nat_equals_prefix.
     seq!
    ) (= (curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? (Poly%vstd!seq.Seq<u8.>.
       seq!
      )
     ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       seq!
      ) (I (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. seq!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_seq_as_nat_equals_prefix.
     seq!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_seq_as_nat_equals_prefix._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_seq_as_nat_equals_prefix._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_prefix_equals_suffix_partial
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial.
 (Dcr Type %%Function%% Int) Bool
)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! %%Function%%) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial.
     N&. N& bytes! k!
    ) (=>
     %%global_location_label%%58
     (<= k! (const_int N&))
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial.
     N&. N& bytes! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial.
 (Dcr Type %%Function%% Int) Bool
)
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! %%Function%%) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial.
     N&. N& bytes! k!
    ) (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
       $ (ARRAY $ (UINT 8) N&. N&) (Poly%array%. bytes!)
      ) (I k!)
     ) (Sub (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& (Poly%array%.
        bytes!
       ) (I 0)
      ) (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& (Poly%array%. bytes!)
       (I k!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial.
     N&. N& bytes! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_partial._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_prefix_equals_suffix_full
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_full.
 (Dcr Type %%Function%%) Bool
)
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_full.
     N&. N& bytes!
    ) (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
       $ (ARRAY $ (UINT 8) N&. N&) (Poly%array%. bytes!)
      ) (I (const_int N&))
     ) (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& (Poly%array%. bytes!)
      (I 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_full.
     N&. N& bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_full._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_prefix_equals_suffix_full._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_equals_suffix_64
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_suffix_64.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_suffix_64.
     bytes!
    ) (= (curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? (vstd!view.View.view.? $
       (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!)
      )
     ) (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? $ (CONST_INT 64) (Poly%array%.
       bytes!
      ) (I 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_suffix_64.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_suffix_64._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_suffix_64._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_words_as_nat_equals_bytes
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes.
 (%%Function%% %%Function%% Int) Bool
)
(declare-const %%global_location_label%%59 Bool)
(declare-const %%global_location_label%%60 Bool)
(assert
 (forall ((words! %%Function%%) (bytes! %%Function%%) (count! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes.
     words! bytes! count!
    ) (and
     (=>
      %%global_location_label%%59
      (let
       ((tmp%%$ count!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%60
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 8)
              ) (Poly%array%. words!)
             ) k$
            )
           ) (curve25519_dalek!specs.core_specs.word64_from_bytes.? (vstd!view.View.view.? $ (
              ARRAY $ (UINT 8) $ (CONST_INT 64)
             ) (Poly%array%. bytes!)
            ) k$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 8)
           ) (Poly%array%. words!)
          ) k$
        ))
        :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes.? (vstd!view.View.view.?
           $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!)
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_words_as_nat_equals_bytes_135
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_words_as_nat_equals_bytes_135
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes.
     words! bytes! count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes.
 (%%Function%% %%Function%% Int) Bool
)
(assert
 (forall ((words! %%Function%%) (bytes! %%Function%%) (count! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes.
     words! bytes! count!
    ) (= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
       $ (UINT 64) $ (CONST_INT 8) (Poly%array%. words!)
      ) (I count!) (I 64)
     ) (curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? (vstd!view.View.view.?
       $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!)
      ) (I count!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes.
     words! bytes! count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_equals_bytes._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_words64_from_bytes_to_nat_wide
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words64_from_bytes_to_nat_wide.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words64_from_bytes_to_nat_wide.
     bytes!
    ) (= (curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? (vstd!view.View.view.?
       $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!)
      ) (I 8)
     ) (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (curve25519_dalek!specs.core_specs.word64_from_bytes.?
                    (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
                    (I 0)
                   ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 64)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
                      (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
                      (I 1)
                  ))))
                 ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 128)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
                    (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
                    (I 2)
                ))))
               ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 192)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
                  (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
                  (I 3)
              ))))
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 256)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
                (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
                (I 4)
            ))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 320)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
              (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
              (I 5)
          ))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 384)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
            (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
            (I 6)
        ))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 448)) (curve25519_dalek!specs.core_specs.word64_from_bytes.?
          (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64)) (Poly%array%. bytes!))
          (I 7)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words64_from_bytes_to_nat_wide.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words64_from_bytes_to_nat_wide._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words64_from_bytes_to_nat_wide._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_words_as_nat_upper_bound
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(assert
 (forall ((words! %%Function%%) (count! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
     words! count!
    ) (and
     (=>
      %%global_location_label%%61
      (let
       ((tmp%%$ count!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%62
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 8)
              ) (Poly%array%. words!)
             ) k$
            )
           ) (vstd!arithmetic.power2.pow2.? (I 64))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 8)
           ) (Poly%array%. words!)
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_words_as_nat_upper_bound_138
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_words_as_nat_upper_bound_138
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
     words! count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
 (%%Function%% Int) Bool
)
(assert
 (forall ((words! %%Function%%) (count! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
     words! count!
    ) (<= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
       $ (UINT 64) $ (CONST_INT 8) (Poly%array%. words!)
      ) (I count!) (I 64)
     ) (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Mul count! 64)))) 1)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
     words! count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound._definition
)))

;; Function-Def curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_words_as_nat_upper_bound
;; curve25519-dalek/src/lemmas/common_lemmas/to_nat_lemmas.rs:837:1: 837:74 (#0)
(get-info :all-statistics)
(push)
 (declare-const words! %%Function%%)
 (declare-const count! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Int)
 (declare-const tmp%5 Int)
 (declare-const pow_prefix@ Int)
 (declare-const pow64@ Int)
 (declare-const word_i@ Int)
 (declare-const prefix_i@ Int)
 (declare-const idx@ Int)
 (declare-const word_val@ Int)
 (declare-const decrease%init0 Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%array%. words!) (ARRAY $ (UINT 64) $ (CONST_INT 8)))
 )
 (assert
  (let
   ((tmp%%$ count!))
   (and
    (<= 0 tmp%%$)
    (<= tmp%%$ 8)
 )))
 (assert
  (forall ((k$ Poly)) (!
    (=>
     (has_type k$ INT)
     (=>
      (let
       ((tmp%%$ (%I k$)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 8)
      ))
      (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 8)
          ) (Poly%array%. words!)
         ) k$
        )
       ) (vstd!arithmetic.power2.pow2.? (I 64))
    )))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
        $ (CONST_INT 8)
       ) (Poly%array%. words!)
      ) k$
    ))
    :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_words_as_nat_upper_bound_140
    :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_words_as_nat_upper_bound_140
 )))
 (declare-const %%switch_label%%0 Bool)
 ;; could not prove termination
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%4 Bool)
 (assert
  (not (=>
    (= decrease%init0 count!)
    (=>
     (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
     (=>
      (exists ((fuel% Fuel)) (= fuel_nat%curve25519_dalek!specs.core_specs.words_as_nat_gen.
        (succ (succ (succ (succ (succ (succ (succ (succ fuel%))))))))
      ))
      (or
       (and
        (=>
         (= count! 0)
         (=>
          (ens%vstd!arithmetic.power2.lemma2_to64. 0)
          %%switch_label%%0
        ))
        (=>
         (not (= count! 0))
         (=>
          (= idx@ (Sub count! 1))
          (and
           (=>
            %%location_label%%0
            (check_decrease_int (let
              ((words!$0 words!) (count!$1 idx@))
              count!$1
             ) decrease%init0 false
           ))
           (and
            (=>
             %%location_label%%1
             (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
              words! idx@
            ))
            (=>
             (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_words_as_nat_upper_bound.
              words! idx@
             )
             (=>
              (= word_val@ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 8)
                  ) (Poly%array%. words!)
                 ) (I idx@)
              )))
              (=>
               (= tmp%1 (Sub (vstd!arithmetic.power2.pow2.? (I 64)) 1))
               (=>
                (= tmp%2 (vstd!arithmetic.power2.pow2.? (I (nClip (Mul idx@ 64)))))
                (=>
                 (= tmp%3 (vstd!arithmetic.power2.pow2.? (I (nClip (Mul idx@ 64)))))
                 (and
                  (=>
                   %%location_label%%2
                   (req%vstd!arithmetic.mul.lemma_mul_upper_bound. word_val@ tmp%1 tmp%2 tmp%3)
                  )
                  (=>
                   (ens%vstd!arithmetic.mul.lemma_mul_upper_bound. word_val@ tmp%1 tmp%2 tmp%3)
                   (and
                    (=>
                     (= pow_prefix@ (vstd!arithmetic.power2.pow2.? (I (nClip (Mul idx@ 64)))))
                     (=>
                      (= pow64@ (vstd!arithmetic.power2.pow2.? (I 64)))
                      (=>
                       (= word_i@ word_val@)
                       (=>
                        (= prefix_i@ (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
                           $ (UINT 64) $ (CONST_INT 8) (Poly%array%. words!)
                          ) (I idx@) (I 64)
                        ))
                        (=>
                         (= tmp%4 (nClip (Mul idx@ 64)))
                         (=>
                          (ens%vstd!arithmetic.power2.lemma_pow2_adds. tmp%4 64)
                          (=>
                           (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. pow_prefix@ pow64@ word_i@)
                           (=>
                            (= tmp%5 (Sub (Sub pow64@ 1) word_i@))
                            (=>
                             (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. pow_prefix@ tmp%5 1)
                             (=>
                              %%location_label%%3
                              (<= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
                                 $ (UINT 64) $ (CONST_INT 8) (Poly%array%. words!)
                                ) (I count!) (I 64)
                               ) (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Mul count! 64)))) 1)
                    )))))))))))
                    (=>
                     (<= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
                        $ (UINT 64) $ (CONST_INT 8) (Poly%array%. words!)
                       ) (I count!) (I 64)
                      ) (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Mul count! 64)))) 1)
                     )
                     %%switch_label%%0
       ))))))))))))))
       (and
        (not %%switch_label%%0)
        (=>
         %%location_label%%4
         (<= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
            $ (UINT 64) $ (CONST_INT 8) (Poly%array%. words!)
           ) (I count!) (I 64)
          ) (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Mul count! 64)))) 1)
 )))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
